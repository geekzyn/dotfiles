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
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Escape and Clear hlsearch" })

-- Tabs
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })

-- Windows
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = "Split window vertically", noremap = true, silent = true })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = "Split window horizontally", noremap = true, silent = true })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = "Delete window", noremap = true, silent = true }) 
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = "Make split windows equal width & height", noremap = true, silent = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper window' })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<Up>', ':resize -2<CR>', { desc = "Increase window height", noremap = true, silent = true })
vim.keymap.set('n', '<Down>', ':resize +2<CR>', { desc = "Decrease window height", noremap = true, silent = true })
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', { desc = "Increase window width", noremap = true, silent = true })
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', { desc = "Decrease window width", noremap = true, silent = true })

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down", silent = true })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up", silent = true })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down", silent = true })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up", silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })

-- Stay in visual mode while indenting
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- File management
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>',{ desc = "Quit file" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Other
vim.keymap.set('v', 'p', '"_dP', { desc = "Keep last yanked when pasting", noremap = true, silent = true })
vim.keymap.set('n', 'x', '"_x', { desc = "Delete character without copying into register", noremap = true, silent = true })
