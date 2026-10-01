# dotfiles

macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory except `homebrew` is a stow package mirroring its target layout under `$HOME`.

Apple Silicon only: `install.sh` and `zsh/.zshrc` hard-code `/opt/homebrew`.

## Setup

```sh
git clone https://github.com/geekzyn/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && sh install.sh
```

Run it from `~/.dotfiles`: the Brewfile path is hard-coded, and stow uses the current directory as its stow directory. In order, `install.sh`:

1. Installs Homebrew if missing and adds its `shellenv` to `~/.zprofile`
2. Runs `brew update`, then `brew bundle` against `homebrew/Brewfile`
3. Installs Claude Code with the native installer, see [Claude Code](#claude-code)
4. Stows `zsh mise nvim vscode aerospace starship`
5. Installs uv with mise, then Python 3.14 with uv, and makes it the default `python`/`python3`. The version is pinned because an unversioned `uv python install` keeps whatever managed Python is already there.
6. Runs `mise install` for the remaining global tools in `mise/.config/mise/config.toml`. Python comes first so Python-based tools build on 3.14 instead of uv downloading an older version.
## Packages

| Package     | Links into `$HOME`                                                                     |
| ----------- | -------------------------------------------------------------------------------------- |
| `zsh`       | `.zshrc`, `.hushlogin`                                                                 |
| `nvim`      | `.config/nvim`, a lazy.nvim setup with a separate keymap and options set for VS Code   |
| `starship`  | `.config/starship/starship.toml`, found through `STARSHIP_CONFIG` in `.zshrc`          |
| `aerospace` | `.config/aerospace/aerospace.toml`                                                     |
| `mise`      | `.config/mise/config.toml`                                                             |
| `vscode`    | `Library/Application Support/Code/User/settings.json` and `keybindings.json`           |

`homebrew` is not stowed; `install.sh` reads the Brewfile in place.

After adding a file to a package, restow it:

```sh
cd ~/.dotfiles && stow zsh mise nvim vscode aerospace starship
```

## Homebrew

`homebrew/Brewfile` holds formulae, casks and VS Code extensions, grouped by purpose. The three third-party taps carry `trusted: true`, so `brew bundle install` trusts them before it loads anything from them, with no separate `brew trust` step.

```sh
brew bundle --file=~/.dotfiles/homebrew/Brewfile           # install and upgrade
brew bundle check --file=~/.dotfiles/homebrew/Brewfile     # report anything missing
brew bundle cleanup --file=~/.dotfiles/homebrew/Brewfile   # list what is installed but not declared
```

`brew bundle cleanup --force` uninstalls those packages and also resets Homebrew's trust store to the trust the Brewfile declares, so declare trust here rather than with `brew trust`.

## Claude Code

Installed with the native installer, not the Homebrew cask, so it auto-updates in the background and picks up new models as they ship. The `claude-code` cask tracks the stable channel, lags roughly a week and never auto-updates (source: Anthropic, "Quickstart", Claude Code documentation, accessed 26 July 2026).

`install.sh` runs this if `~/.local/bin/claude` is absent:

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

Layout: versions land in `~/.local/share/claude/versions/<version>`, with `~/.local/bin/claude` symlinked to the active one. `zsh/.zshrc` already puts `~/.local/bin` on `PATH`, so no extra entry is needed.

Check the running version with `claude --version`, or `claude update` to pull an update immediately.
