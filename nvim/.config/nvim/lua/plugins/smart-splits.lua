-- Split pane management
-- Supports seamless navigation between Neovim and terminal multiplexer split panes
return {
	"mrjones2014/smart-splits.nvim",
	opts = {
		at_edge = "wrap",
	},
	config = function(_, opts)
		-- change focus window
		vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move to left window" })
		vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move to down window" })
		vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move to up window" })
		vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move to right window" })
		-- resize window
		vim.keymap.set("n", "<A-Left>", require("smart-splits").resize_left, { desc = "smart resize left" })
		vim.keymap.set("n", "<A-Down>", require("smart-splits").resize_down, { desc = "smart resize down" })
		vim.keymap.set("n", "<A-Up>", require("smart-splits").resize_up, { desc = "smart resize up" })
		vim.keymap.set("n", "<A-Right>", require("smart-splits").resize_right, { desc = "smart resize right" })

		require("smart-splits").setup(opts)
	end,
}
