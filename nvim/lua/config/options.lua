-- [[ Setting options ]]
-- See `:help vim.opt`
-- For more options, you can see `:help option-list`
vim.opt.autowrite = true -- enable auto write
vim.opt.number = true -- line numbers
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- enable highlighting of the current line
vim.opt.scrolloff = 10 -- minimal number of screen lines to keep above and below the current line
vim.opt.mouse = 'a' -- enable mouse mode
vim.opt.showmode = false -- disable show mode (since we have a statusline plugin)
vim.opt.undofile = true -- save undo history
vim.opt.inccommand = "nosplit" -- preview incremental substitution
vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one
vim.opt.smartindent = true -- insert indents automatically
vim.opt.wrap = false -- disable line wrap (display lines as one long line) 
vim.opt.linebreak = true -- wrap lines at convenient points
vim.opt.breakindent = true -- enable break indent to indent wrapped line

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  only set clipboard if not in ssh, to make sure the OSC 52
--  integration works automatically. Requires Neovim >= 0.10.0
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
end)

-- Case-insensitive Searching 
-- UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
vim.opt.updatetime = 200 -- decrease update time
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300 -- decrease mapped sequence wait time, lower than default (1000) to quickly trigger which-key

vim.opt.splitright = true -- new horizontal windows right of current
vim.opt.splitbelow = true -- new vertical windows below current
vim.opt.splitkeep = "screen"

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { trail = '·', nbsp = '␣' }

-- Sets colorscheme
vim.opt.termguicolors = false
vim.cmd.colorscheme 'habamax'

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
