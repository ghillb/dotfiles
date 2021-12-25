local fn = vim.fn

-- bootstrap packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd("packadd packer.nvim")
end

-- auto compile
vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

vim.api.nvim_set_keymap(
  "n",
  "<localleader>pu",
  ":source $MYVIMRC<cr> :PackerSync<cr>",
  { noremap = true, silent = false }
)

vim.api.nvim_set_keymap(
  "n",
  "<localleader>ps",
  ":source $MYVIMRC<cr> :PackerStatus<cr>",
  { noremap = true, silent = false }
)

return require("packer").startup({
  function(use)
    use({ "wbthomason/packer.nvim" })

    use({ "morhetz/gruvbox" })
    use({ "habamax/vim-gruvbit" })
    use({ "rebelot/kanagawa.nvim" })
    use({ "tpope/vim-fugitive" })
    use({ "will133/vim-dirdiff" })
    use({ "junegunn/gv.vim" })
    use({ "tpope/vim-surround" })
    use({ "stevearc/qf_helper.nvim" })
    use({ "goolord/alpha-nvim" })
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
    use({ "GustavoKatel/telescope-asynctasks.nvim" })

    -- lua
    use({ "neovim/nvim-lspconfig", git = { subcommands = { update_branch = "merge" } } })
    use({ "williamboman/nvim-lsp-installer" })
    use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } })
    use({ "nvim-treesitter/nvim-treesitter", branch = "master" })
    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
      },
    })
    use({ "nvim-telescope/telescope-project.nvim" })
    use({ "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" } })
    use({ "nvim-telescope/telescope-cheat.nvim", requires = { "tami5/sqlite.lua" } })
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
    use({ "nathom/filetype.nvim" })
    use({ "windwp/nvim-autopairs" })
    use({ "lewis6991/gitsigns.nvim" })
    use({ "sindrets/diffview.nvim" })
    use({ "lukas-reineke/indent-blankline.nvim" })
    use({ "folke/trouble.nvim", requires = { "kyazdani42/nvim-web-devicons" } })
    use({ "folke/todo-comments.nvim", requires = { "nvim-lua/plenary.nvim" } })
    use({ "tjdevries/astronauta.nvim" })
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
    use({ "akinsho/nvim-bufferline.lua" })
    use({ "nvim-lualine/lualine.nvim", opt = false })
    use({ "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" } })
    use({ "simrat39/rust-tools.nvim", requires = { "neovim/nvim-lspconfig" } })
    use({ "mcchrish/nnn.vim" })
    use({ "abecodes/tabout.nvim", wants = { "nvim-treesitter" } })
    use({ "p00f/nvim-ts-rainbow" })
    use({ "ellisonleao/glow.nvim" })
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
        ft.set("gitlab-ci", { "#%s", "#%s" }).set("ansible", { "#%s", "#%s" })
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
