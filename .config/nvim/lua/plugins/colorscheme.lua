return {
  -- Poimandres theme
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("poimandres").setup {}
    end,
    init = function()
      vim.cmd("colorscheme poimandres")
    end,
  },

  -- Configure LazyVim to load poimandres
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "poimandres",
    },
  },
}


