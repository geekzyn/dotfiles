return  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        open_mapping = [[<c-/>]],
        direction = "float",
        hide_numbers = true,
        terminal_mappings = true,
        shell = "zsh",
        float_opts = {
          border = 'single',
          width = 80,
          height = 20,
        },
      }
    end,
    lazy = false,
}
