local fn = vim.fn

-- bootstrap packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

-- auto compile
vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

vim.api.nvim_set_keymap(
    'n',
    '<localleader>pu',
    ":source $MYVIMRC<cr> :PackerSync<cr>",
    {noremap = true, silent = false}
)

vim.api.nvim_set_keymap(
    'n',
    '<localleader>ps',
    ":source $MYVIMRC<cr> :PackerStatus<cr>",
    {noremap = true, silent = false}
)

return require('packer').startup({
  function(use)
    use {'wbthomason/packer.nvim'}

    use {'morhetz/gruvbox'}
    use {'habamax/vim-gruvbit'}
    use {'tpope/vim-fugitive'}
    use {'will133/vim-dirdiff'}
    use {'junegunn/gv.vim'}
    use {'tpope/vim-surround'}
    use {'stevearc/qf_helper.nvim'}
    use {'goolord/alpha-nvim'}
    use {'vimwiki/vimwiki', branch = 'dev'}
    use {'nvim-neorg/neorg', requires = {'nvim-lua/plenary.nvim'} }
    use {'mbbill/undotree'}
    use {'kassio/neoterm'}
    use {'metakirby5/codi.vim'}
    use {'ggandor/lightspeed.nvim', requires = {'tpope/vim-repeat'} }
    use {'hrsh7th/vim-vsnip'}
    use {'rafamadriz/friendly-snippets'}
    use {'Jorengarenar/vim-MvVis'}
    use {'skywind3000/asynctasks.vim', requires = {'skywind3000/asyncrun.vim'} }
    use {'GustavoKatel/telescope-asynctasks.nvim'}

    -- lua
    use {'neovim/nvim-lspconfig', git = { subcommands = { update_branch = 'merge' } } }
    use {'williamboman/nvim-lsp-installer'}
    use {'nvim-treesitter/nvim-treesitter', branch = '0.5-compat'}
    use {'nvim-telescope/telescope.nvim',
      requires = {
        {'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'}
      }
    }
    use {'nvim-telescope/telescope-project.nvim'}
    use {'nvim-telescope/telescope-frecency.nvim', requires = {"tami5/sqlite.lua"}}
    use {'hrsh7th/nvim-cmp',
      requires = {
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'hrsh7th/cmp-vsnip'},
        {'hrsh7th/cmp-nvim-lua'},
        {'hrsh7th/cmp-nvim-lsp'}
      }
    }
    use {'onsails/lspkind-nvim'}
    use {'ray-x/lsp_signature.nvim'}
    use {'stevearc/aerial.nvim'}
    use {'mhartington/formatter.nvim'}
    use {'nathom/filetype.nvim'}
    use {'windwp/nvim-autopairs'}
    use {'lewis6991/gitsigns.nvim'}
    use {'sindrets/diffview.nvim'}
    use {'lukas-reineke/indent-blankline.nvim'}
    use {'folke/trouble.nvim',
      requires = {"kyazdani42/nvim-web-devicons"},
    }
    use {'folke/todo-comments.nvim',
      requires = {"nvim-lua/plenary.nvim"},
    }
    use {"folke/which-key.nvim",
      event = "VimEnter",
      cond = function() return vim.api.nvim_eval('!exists("g:vscode")') end,
      config = function()
        require("which-key").setup{
          window = {
            border = "single"
          }
        }
      end
    }
    use({
      "folke/persistence.nvim",
      event = "BufReadPre",
      module = "persistence",
      config = function()
        require("persistence").setup()
      end,
    })
    use {'folke/twilight.nvim'}
    use {'folke/zen-mode.nvim'}
    use {'norcalli/nvim-colorizer.lua'}
    use {'akinsho/nvim-bufferline.lua'}
    use {'nvim-lualine/lualine.nvim', opt = false}
    use {'kyazdani42/nvim-tree.lua',
      requires = {"kyazdani42/nvim-web-devicons"},
    }
    use {'simrat39/rust-tools.nvim',
      requires = {"neovim/nvim-lspconfig"},
    }
    use {'mcchrish/nnn.vim'}
    use {'abecodes/tabout.nvim', wants = {'nvim-treesitter'}}
    use {"ellisonleao/glow.nvim"}
    use {'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
        local ft = require('Comment.ft')
        ft.set('gitlab-ci', {'#%s', '#%s'}).set('ansible', {'#%s', '#%s'})
      end
    }

  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})

