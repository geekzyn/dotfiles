-- [[ Basic Keymaps ]
--  See `:help im.keymap.set()`

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Escape and Clear hlsearch' })

-- Buffers (in-memory text of a file)
vim.keymap.set('n', '<leader><Tab>', '<cmd>enew<cr>', { desc = 'New buffer', noremap = true, silent = true })
vim.keymap.set('n', '<leader><Tab>d', ':bdelete!<cr>', { desc = 'Delete buffer', noremap = true, silent = true })
vim.keymap.set('n', '<Tab>', '<cmd>bnext<cr>', { desc = 'Next buffer', noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<cr>', { desc = 'Previous buffer', noremap = true, silent = true })

-- Windows (viewport on a buffer)
vim.keymap.set('n', '<leader>|', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>-', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete window' })
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = 'Make windows equal width & height' })

-- Tabs (collection of windows)
vim.keymap.set('n', '<leader>to', '<cmd>tabnew<cr>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>td', '<cmd>tabclose<cr>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<cr>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })

-- Smart-splits pliugin is used for window mangement with Wezterm 
-- -- Keybinds to make split navigation easier.
-- --  Use CTRL+<hjkl> to switch between windows
-- --  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper window' })
--
-- -- Resize windows
-- vim.keymap.set("n", "<A-Up>", ":resize -2<CR>", { desc = "Increase window height" })
-- vim.keymap.set("n", "<A-Down>", ":resize +2<CR>", { desc = "Decrease window height" })
-- vim.keymap.set("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Decrease window width" })
-- vim.keymap.set("n", "<A-Left>",	":vertical resize -2<CR>", { desc = "Increase window width" })

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided.
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move lines
vim.keymap.set('n', 'J', '<cmd>m .+1<cr>==', { desc = 'Move down', silent = true })
vim.keymap.set('n', 'K', '<cmd>m .-2<cr>==', { desc = 'Move up', silent = true })
vim.keymap.set('i', 'J', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down', silent = true })
vim.keymap.set('i', 'K', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up', silent = true })
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move down', silent = true })
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move up', silent = true })

-- Stay in visual mode while indenting
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- File management
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', { desc = 'Quit file' })
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Other
vim.keymap.set('v', 'p', '"_dP', { desc = 'Keep last yanked when pasting', noremap = true, silent = true })
vim.keymap.set('n', 'x', '"_x', { desc = 'Delete character without copying into register', noremap = true, silent = true })
vim.keymap.set("n", "c", '"_c', { desc = 'Change text without copying into register', noremap = true, silent = true })
vim.keymap.set("x", "c", '"_c', { desc = 'Change text without copying into register', noremap = true, silent = true })
vim.keymap.set("n", "cc", '"_cc', { desc = 'Change line without copying into register', noremap = true, silent = true })
vim.keymap.set("n", "C", '"_C', { desc = 'Change text until EOL without copying into register', noremap = true, silent = true })

-- -- Terminal
-- vim.keymap.set('n', '<leader>to', ':split term://zsh<CR>:resize 10<CR>', { desc = 'Open integrated terminal', noremap = true, silent = true })
-- vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Normal mode in integrated terminal', noremap = true, silent = true })
-- vim.keymap.set('t', '<C-d>', 'exit<CR>', { desc = 'Close integrated terminal', noremap = true, silent = true })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev warning" })
