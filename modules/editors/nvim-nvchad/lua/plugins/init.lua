return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    lazy = false,
    ---@type oil.SetupOpts
    opts = {
      columns = {
        "icon",
        "permissions",
        "mtime"
      },
      view_options = {
        show_hidden = true
      }
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>gl", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  }
}
