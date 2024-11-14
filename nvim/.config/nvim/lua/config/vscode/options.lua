-- [[ Setting options ]]
-- See `:help vim.opt`
-- For more options, you can see `:help option-list`

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
