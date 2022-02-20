local fn = vim.fn

-- bootstrap packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd("packadd packer.nvim")
end

-- auto compile
vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

return require("packer").startup({
  function(use)
    use({ "wbthomason/packer.nvim" })
    use({ "gruvbox-community/gruvbox" })
    use({ "rebelot/kanagawa.nvim" })
    use({ "navarasu/onedark.nvim" })
    use({ "tpope/vim-fugitive" })
    use({ "will133/vim-dirdiff" })
    use({ "junegunn/gv.vim" })
    use({ "tpope/vim-surround" })
    use({ "vimwiki/vimwiki", branch = "dev" })
    use({ "nvim-neorg/neorg", requires = { "nvim-lua/plenary.nvim" } })
    use({ "mbbill/undotree" })
    use({ "kassio/neoterm" })
    use({ "metakirby5/codi.vim" })
    use({ "chaoren/vim-wordmotion" })
    use({ "arthurxavierx/vim-caser" })
    use({ "ggandor/lightspeed.nvim", requires = { "tpope/vim-repeat" } })
    use({ "hrsh7th/vim-vsnip" })
    use({ "RRethy/vim-illuminate" })
    use({ "rafamadriz/friendly-snippets" })
    use({ "Jorengarenar/vim-MvVis" })
    use({ "skywind3000/asynctasks.vim", requires = { "skywind3000/asyncrun.vim" } })
    use({ "neovim/nvim-lspconfig", git = { subcommands = { update_branch = "merge" } } })
    use({ "williamboman/nvim-lsp-installer" })
    use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } })
    use({ "nvim-treesitter/nvim-treesitter", branch = "master" })
    use({
      "mfussenegger/nvim-dap",
      requires = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "Pocco81/DAPInstall.nvim",
      },
    })
    use({ "rcarriga/vim-ultest", requires = { "vim-test/vim-test" }, run = ":UpdateRemotePlugins" })
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-project.nvim" },
        { "nvim-telescope/telescope-dap.nvim" },
        { "nvim-telescope/telescope-rg.nvim" },
        { "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" } },
        { "nvim-telescope/telescope-cheat.nvim", requires = { "tami5/sqlite.lua" } },
        { "GustavoKatel/telescope-asynctasks.nvim" },
      },
    })
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-vsnip" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-cmdline" },
      },
    })
    use({ "onsails/lspkind-nvim" })
    use({ "ray-x/lsp_signature.nvim" })
    use({ "kosayoda/nvim-lightbulb" })
    use({ "stevearc/aerial.nvim" })
    use({ "windwp/nvim-autopairs" })
    use({ "lewis6991/gitsigns.nvim" })
    use({ "sindrets/diffview.nvim" })
    use({ "akinsho/toggleterm.nvim" })
    use({ "lukas-reineke/indent-blankline.nvim" })
    use({ "folke/trouble.nvim", requires = { "kyazdani42/nvim-web-devicons" } })
    use({ "folke/todo-comments.nvim", requires = { "nvim-lua/plenary.nvim" } })
    use({
      "folke/which-key.nvim",
      event = "VimEnter",
      cond = function()
        return vim.api.nvim_eval('!exists("g:vscode")')
      end,
      config = function()
        require("which-key").setup({
          window = {
            border = "single",
          },
        })
      end,
    })
    use({
      "folke/persistence.nvim",
      event = "BufReadPre",
      module = "persistence",
      config = function()
        require("persistence").setup()
      end,
    })
    use({ "folke/twilight.nvim" })
    use({ "folke/zen-mode.nvim" })
    use({
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end,
    })
    use({ "nanozuki/tabby.nvim" })
    use({ "nvim-lualine/lualine.nvim", opt = false })
    use({ "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" } })
    use({ "simrat39/rust-tools.nvim", requires = { "neovim/nvim-lspconfig" } })
    use({ "mcchrish/nnn.vim" })
    use({ "abecodes/tabout.nvim", wants = { "nvim-treesitter" } })
    use({ "wellle/targets.vim" })
    use({ "p00f/nvim-ts-rainbow" })
    use({ "stevearc/qf_helper.nvim" })
    use({ "goolord/alpha-nvim" })
    use({ "kenn7/vim-arsync" })
    use({ "ellisonleao/glow.nvim" })
    use({
      "danymat/neogen",
      config = function()
        require("neogen").setup({
          enabled = true,
        })
      end,
      requires = "nvim-treesitter/nvim-treesitter",
    })
    use({
      "AckslD/nvim-neoclip.lua",
      config = function()
        require("neoclip").setup({ default_register = { '"', "+", "*" } })
      end,
    })
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup({ ignore = "^$" })
        local ft = require("Comment.ft")
        local comment_strings = { "#%s", "#%s" }
        ft.set("gitlab-ci", comment_strings).set("ansible", comment_strings).set("docker-compose", comment_strings)
      end,
    })
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },
  },
})
