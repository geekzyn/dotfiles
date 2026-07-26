# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package mirroring its target layout under `$HOME`.

```sh
cd ~/.dotfiles && stow zsh nvim starship wezterm aerospace kitty scripts vscode aichat launchd
```

ln -s ~/.dotfiles/claude/commands ~/.claude

## Claude Code

Installed with the native installer, not the Homebrew cask, so it auto-updates in the background and picks up new models as they ship. The `claude-code` cask tracks the stable channel, lags roughly a week and never auto-updates (source: Anthropic, "Quickstart", Claude Code documentation, accessed 26 July 2026).

`install.sh` runs this if `~/.local/bin/claude` is absent:

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

Layout: versions land in `~/.local/share/claude/versions/<version>`, with `~/.local/bin/claude` symlinked to the active one. `~/.local/bin` is already on PATH via the `~/.local/bin/env` shim sourced in `zsh/.zshrc`, so no extra PATH entry is needed.

Check the running version with `claude --version`, or `claude update` to pull an update immediately.

## aichat on a Claude subscription, no API key

aichat authenticates to Anthropic with an `x-api-key` header, and a Pro/Max
subscription issues OAuth tokens scoped to Claude Code instead. There is no
aichat config that bridges the two, so a local shim does it:

```
aichat  ->  http://localhost:8317/v1  ->  claude -p  ->  Anthropic
```

`scripts/.local/scripts/claude-openai-shim.py` serves the OpenAI chat API from
the stdlib, no dependencies, and runs every request through the Claude Code
CLI. Claude Code performs the authentication; the shim never reads credentials.

- `local.claude-openai-shim` keeps it running, `RunAtLoad` plus `KeepAlive`
- Runs on `~/.local/bin/python3`, the uv-managed default. launchd needs an
  absolute path, and this keeps the agent on the same python as everything else
- Logs at `~/Library/Logs/claude-openai-shim.log`, one line per request
- Bound to 127.0.0.1. The endpoint has no auth, and whoever reaches it spends
  the subscription quota
- Tunables via the plist: `CLAUDE_SHIM_ADDR`, `CLAUDE_SHIM_MODEL`,
  `CLAUDE_SHIM_TIMEOUT`, `CLAUDE_SHIM_THINKING`, `CLAUDE_SHIM_BIN`

```sh
launchctl bootstrap gui/$UID ~/Library/LaunchAgents/local.claude-openai-shim.plist   # start
launchctl bootout gui/$UID/local.claude-openai-shim                                  # stop
curl -s localhost:8317/healthz                                                       # check
```

Limits worth knowing:

- About 2,5s per turn on haiku, most of it CLI startup. Set
  `CLAUDE_SHIM_THINKING` above 0 for harder work, at roughly double the latency
- Function and tool calling do not work. The shim runs `claude` with `--tools ''`,
  which is what keeps it a single model call
- Every request carries the account-level system prompt from Claude Code, worth
  roughly 870 input tokens, and it shapes the writing style. Managed settings
  cannot be switched off from the client
- Multi-turn conversations are flattened into one labelled transcript, since
  `claude -p` takes a single prompt string

### llm: natural language to shell command

`zsh/.zshrc` keeps `llm` as a one-line wrapper around `aichat -e`, so the
request needs no quoting and the execute, revise, describe and copy menu comes
from aichat itself:

```
$ llm count files in the current directory
find . -maxdepth 1 -type f | wc -l
? execute | revise | describe | copy | quit: (e)
```

This depends on the shim being up. If it is not, aichat fails with a connection
error on port 8317.

## kitty: btop wallpaper and quick-access overlay

Two independent btop instances, both rendered by kitty:

**1. Wallpaper (read-only)**. A background panel that draws btop as the desktop wallpaper. Background panels never receive input, so this is display-only:

```sh
open -na kitty.app --args +kitten panel --edge=background -o background_opacity=0.2 -o background=black btop
```

**2. Interactive overlay (toggle)**. A centred quick-access terminal for acting on processes (select, press `k` to kill). Configured in `kitty/.config/kitty/quick-access-terminal.conf`, toggled with `scripts/.local/scripts/btop-toggle.sh` (stowed to `~/.local/scripts`):

```sh
~/.local/scripts/btop-toggle.sh   # first run starts the overlay, later runs toggle visibility
```

Notes:
- The script invokes the kitten binary directly. Launching via `open -na kitty.app` fails silently while the wallpaper panel occupies the kitty-quick-access helper app
- `hide_on_focus_loss yes` dismisses the overlay when it loses focus
- The script carries Raycast metadata: add `~/.local/scripts` as a Script Command directory in Raycast and assign a hotkey to "Toggle btop overlay"

After a reboot:
- Overlay: nothing to do. The toggle script is self-healing; the first hotkey press starts a fresh overlay, later presses toggle it. Do not set `start_as_hidden yes` in the conf, or the first press would start it invisible and need a second press
- Wallpaper: relaunch manually with the panel command above
