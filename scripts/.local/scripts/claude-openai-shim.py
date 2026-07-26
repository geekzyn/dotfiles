#!/usr/bin/env python3
"""OpenAI-compatible HTTP endpoint backed by the Claude Code CLI.

Lets any tool that speaks the OpenAI chat API (aichat, and anything else with
an api_base setting) run on a Claude Pro/Max subscription. Every request shells
out to `claude -p`, so Claude Code performs the authentication and no API key
is involved. Credentials are never read by this script.

Endpoints
  GET  /v1/models
  POST /v1/chat/completions   (streaming and non-streaming)
  GET  /healthz

Environment
  CLAUDE_SHIM_ADDR      bind address, default 127.0.0.1:8317
  CLAUDE_SHIM_MODEL     model when the request does not name one, default haiku
  CLAUDE_SHIM_TIMEOUT   seconds before a request is killed, default 300
  CLAUDE_SHIM_THINKING  thinking token budget, default 0 (off, and much faster)
  CLAUDE_SHIM_BIN       path to the claude binary, default the one on PATH

Bind to localhost only. This endpoint has no authentication, and anything that
can reach it spends your subscription quota.
"""

import json
import os
import shutil
import subprocess
import sys
import threading
import time
import uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

ADDR = os.environ.get("CLAUDE_SHIM_ADDR", "127.0.0.1:8317")
DEFAULT_MODEL = os.environ.get("CLAUDE_SHIM_MODEL", "haiku")
TIMEOUT = float(os.environ.get("CLAUDE_SHIM_TIMEOUT", "300"))
THINKING = os.environ.get("CLAUDE_SHIM_THINKING", "0")
CLAUDE = (
    os.environ.get("CLAUDE_SHIM_BIN")
    or shutil.which("claude")
    or os.path.expanduser("~/.local/bin/claude")
)

MODELS = ["haiku", "sonnet", "opus", "fable"]

# No tools, no MCP servers, no settings files, no session written to disk: one
# model call per request and nothing that can touch the filesystem.
BASE_ARGS = [
    "-p",
    "--tools", "",
    "--strict-mcp-config",
    "--mcp-config", '{"mcpServers":{}}',
    "--disable-slash-commands",
    "--setting-sources", "",
    "--no-session-persistence",
]


def log(*parts):
    print(time.strftime("%H:%M:%S"), *parts, file=sys.stderr, flush=True)


def text_of(content):
    """OpenAI content is a string or a list of typed parts."""
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        return "\n".join(
            p.get("text", "")
            for p in content
            if isinstance(p, dict) and p.get("type") == "text"
        )
    return "" if content is None else str(content)


def render(messages):
    """Flatten OpenAI messages into (system prompt, single user prompt).

    `claude -p` takes one prompt string, so a multi-turn conversation becomes a
    labelled transcript. Single-turn requests, which is what aichat -e sends,
    pass through unchanged.
    """
    system, turns = [], []
    for m in messages or []:
        role = m.get("role", "user")
        body = text_of(m.get("content"))
        if not body.strip():
            continue
        if role == "system":
            system.append(body)
        else:
            turns.append((role, body))

    if len(turns) == 1 and turns[0][0] == "user":
        prompt = turns[0][1]
    else:
        label = {"assistant": "Assistant", "tool": "Tool"}
        prompt = "\n\n".join(f"{label.get(r, 'Human')}: {b}" for r, b in turns)
    return "\n\n".join(system), prompt


def spawn(model, system, prompt, stream):
    args = [CLAUDE, *BASE_ARGS, "--model", model]
    if system:
        args += ["--system-prompt", system]
    if stream:
        args += ["--output-format", "stream-json", "--include-partial-messages", "--verbose"]
    else:
        args += ["--output-format", "json"]
    args += ["--", prompt]

    env = dict(os.environ, MAX_THINKING_TOKENS=THINKING)
    return subprocess.Popen(
        args,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=env,
        text=True,
        bufsize=1,
    )


def watchdog(proc):
    """Kill a call that overruns CLAUDE_SHIM_TIMEOUT."""
    timer = threading.Timer(TIMEOUT, proc.kill)
    timer.daemon = True
    timer.start()
    return timer


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    server_version = "claude-openai-shim"

    def log_message(self, *_):
        pass  # we do our own, one line per completed request

    def send_json(self, code, payload):
        body = json.dumps(payload).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def send_error_json(self, code, message, kind="upstream_error"):
        self.send_json(code, {"error": {"message": message, "type": kind}})

    def do_GET(self):
        path = self.path.split("?")[0]
        if path == "/healthz":
            self.send_json(200, {"status": "ok", "claude": CLAUDE})
        elif path in ("/v1/models", "/models"):
            now = int(time.time())
            self.send_json(200, {
                "object": "list",
                "data": [
                    {"id": m, "object": "model", "created": now, "owned_by": "anthropic"}
                    for m in MODELS
                ],
            })
        else:
            self.send_error_json(404, f"unknown path {path}", "invalid_request_error")

    def do_POST(self):
        path = self.path.split("?")[0]
        if path not in ("/v1/chat/completions", "/chat/completions"):
            self.send_error_json(404, f"unknown path {path}", "invalid_request_error")
            return

        length = int(self.headers.get("Content-Length") or 0)
        try:
            req = json.loads(self.rfile.read(length) or b"{}")
        except json.JSONDecodeError as exc:
            self.send_error_json(400, f"invalid JSON body: {exc}", "invalid_request_error")
            return

        model = (req.get("model") or DEFAULT_MODEL).split("/")[-1]
        system, prompt = render(req.get("messages"))
        if not prompt.strip():
            self.send_error_json(400, "no user message in request", "invalid_request_error")
            return

        started = time.time()
        if req.get("stream"):
            self.stream_completion(model, system, prompt, started)
        else:
            self.whole_completion(model, system, prompt, started)

    def whole_completion(self, model, system, prompt, started):
        proc = spawn(model, system, prompt, stream=False)
        timer = watchdog(proc)
        try:
            out, err = proc.communicate()
        finally:
            timer.cancel()

        if proc.returncode != 0:
            log(f"model={model} FAILED rc={proc.returncode} {err.strip()[:200]}")
            self.send_error_json(502, err.strip() or f"claude exited {proc.returncode}")
            return

        try:
            result = json.loads(out)
        except json.JSONDecodeError:
            log(f"model={model} FAILED unparseable output")
            self.send_error_json(502, f"unparseable claude output: {out[:200]}")
            return

        if result.get("is_error"):
            self.send_error_json(502, str(result.get("result") or "claude reported an error"))
            return

        text = result.get("result") or ""
        usage = result.get("usage") or {}
        prompt_tokens = usage.get("input_tokens", 0)
        completion_tokens = usage.get("output_tokens", 0)
        log(f"model={model} {len(text)}c in {time.time() - started:.1f}s "
            f"tokens={prompt_tokens}/{completion_tokens}")

        self.send_json(200, {
            "id": "chatcmpl-" + uuid.uuid4().hex,
            "object": "chat.completion",
            "created": int(started),
            "model": model,
            "choices": [{
                "index": 0,
                "message": {"role": "assistant", "content": text},
                "finish_reason": "stop",
            }],
            "usage": {
                "prompt_tokens": prompt_tokens,
                "completion_tokens": completion_tokens,
                "total_tokens": prompt_tokens + completion_tokens,
            },
        })

    def stream_completion(self, model, system, prompt, started):
        proc = spawn(model, system, prompt, stream=True)
        timer = watchdog(proc)
        chunk_id = "chatcmpl-" + uuid.uuid4().hex
        created = int(started)
        sent_any = False
        chars = 0

        def frame(delta, finish=None):
            return "data: " + json.dumps({
                "id": chunk_id,
                "object": "chat.completion.chunk",
                "created": created,
                "model": model,
                "choices": [{"index": 0, "delta": delta, "finish_reason": finish}],
            }) + "\n\n"

        self.send_response(200)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-cache")
        self.send_header("Connection", "close")
        self.end_headers()

        def write(payload):
            self.wfile.write(payload.encode())
            self.wfile.flush()

        try:
            write(frame({"role": "assistant", "content": ""}))
            for line in proc.stdout:
                try:
                    event = json.loads(line)
                except json.JSONDecodeError:
                    continue
                if event.get("type") != "stream_event":
                    continue
                inner = event.get("event") or {}
                if inner.get("type") != "content_block_delta":
                    continue
                delta = inner.get("delta") or {}
                # text_delta only: thinking_delta and signature_delta are not
                # part of the assistant message
                if delta.get("type") == "text_delta" and delta.get("text"):
                    sent_any = True
                    chars += len(delta["text"])
                    write(frame({"content": delta["text"]}))

            proc.wait()
            if proc.returncode != 0 and not sent_any:
                err = (proc.stderr.read() or "").strip()
                log(f"model={model} FAILED rc={proc.returncode} {err[:200]}")
                write(frame({"content": f"[shim] claude failed: {err[:200]}"}))

            write(frame({}, finish="stop"))
            write("data: [DONE]\n\n")
            log(f"model={model} {chars}c streamed in {time.time() - started:.1f}s")
        except (BrokenPipeError, ConnectionResetError):
            log(f"model={model} client disconnected after {chars}c")
        finally:
            timer.cancel()
            if proc.poll() is None:
                proc.kill()


def main():
    host, _, port = ADDR.rpartition(":")
    if not shutil.which(CLAUDE) and not os.path.exists(CLAUDE):
        sys.exit(f"claude binary not found at {CLAUDE}, set CLAUDE_SHIM_BIN")
    server = ThreadingHTTPServer((host or "127.0.0.1", int(port)), Handler)
    server.daemon_threads = True
    log(f"listening on http://{host}:{port}/v1  model={DEFAULT_MODEL}  bin={CLAUDE}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        log("shutting down")


if __name__ == "__main__":
    main()
