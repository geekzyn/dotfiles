# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package mirroring its target layout under `$HOME`.

```sh
cd ~/.dotfiles && stow zsh nvim starship wezterm aerospace kitty scripts
```

ln -s ~/.dotfiles/claude/commands ~/.claude

`intelli-shell` is not stowed: its config lives under `~/Library/Application Support` on macOS and `commands.bak` is a data file, not a `$HOME` symlink. `install.sh` links the config, pulls the local AI model (`qwen2.5-coder:3b`), and imports the command library and dynamic completions. The pre-commit hook keeps `intelli-shell/commands.bak` in sync.

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
