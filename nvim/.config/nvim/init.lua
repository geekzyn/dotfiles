if vim.g.vscode then
  require "config.vscode.options"
  require "config.vscode.keymaps"
else
  require("config.options")
  require("config.keymaps")
  require("config.lazy")
  require("config.autocmds")
end
