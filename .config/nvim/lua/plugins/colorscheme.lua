return {
  -- Zen theme
  {
    "nendix/zen.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("zen").setup({})
    end,
    init = function()
      vim.cmd("colorscheme zen")
    end,
  },

  -- Configure LazyVim to load zen
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "zen",
    },
  },
}
