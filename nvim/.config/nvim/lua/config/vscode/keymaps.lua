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

-- Buffers (in-memory text of a file) -- in vscode I am using Tabs
vim.keymap.set('n', '<Tab>', "<cmd>lua require('vscode').action('workbench.action.nextEditorInGroup')<CR>")
vim.keymap.set('n', '<S-Tab>', "<cmd>lua require('vscode').action('workbench.action.previousEditorInGroup')<CR>")
-- '<C-Tab>', { desc = 'Open next' })
-- '<C-S>Tab', { desc = 'Open previous' })
-- '<A>p', { desc = 'Go to file' })

-- Windows (viewport on a buffer)
-- '<C-w>v', { desc = 'Split window vertically' })
-- '<C-w>s', { desc = 'Split window horizontally' })
-- '<C-w>c', { desc = 'Close window' })
-- '<C-w>o', { desc = 'Only keep current window' })
-- '<C-w>w', { desc = 'Next window' })
-- '<C-w>W', { desc = 'Previous window' })
-- '<C-w>_', { desc = 'Maximize window height' })
-- '<C-w>|', { desc = 'Increase window width' }) -- in vscode-neovim it's <C-w>_
-- '<C-w>+', { desc = 'Increase window height' })
-- '<C-w>-', { desc = 'Decrease window height' })
-- '<C-w>>', { desc = 'Increase window width' })
-- '<C-w><', { desc = 'Decrease window width' })
-- '<C-w>=', { desc = 'Make windows equal width & height' })
-- '<C-w>hjkl', { desc = 'Navigate windows' })

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided.
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move lines
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move down', silent = true })
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move up', silent = true })

-- Stay in visual mode while indenting
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- Other
vim.keymap.set('v', 'p', '"_dP', { desc = 'Keep last yanked when pasting', noremap = true, silent = true })
vim.keymap.set('n', 'x', '"_x', { desc = 'Delete character without copying into register', noremap = true, silent = true })
vim.keymap.set("n", "c", '"_c', { desc = 'Change text without copying into register', noremap = true, silent = true })
vim.keymap.set("x", "c", '"_c', { desc = 'Change text without copying into register', noremap = true, silent = true })
vim.keymap.set("n", "cc", '"_cc', { desc = 'Change line without copying into register', noremap = true, silent = true })
vim.keymap.set("n", "C", '"_C', { desc = 'Change text until EOL without copying into register', noremap = true, silent = true })

-- Terminal
-- '<C-`>, { desc = 'toggle integrated terminal' })
