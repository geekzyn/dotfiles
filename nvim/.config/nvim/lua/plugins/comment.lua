return {
  'numToStr/Comment.nvim',
  opts = {
    toggler = {
      line = '<C-c>',
      block = '<C-b>',
    },
    opleader = {
      -- visual mode
      line = '<C-c>',
      block = '<C-b>',
    },
  },
  config = function(_, opts)
    require('Comment').setup(opts)
  end
}
