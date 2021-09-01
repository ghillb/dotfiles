local execute = vim.api.nvim_command
local fn = vim.fn

-- bootstrap packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
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
  function()
    use {'wbthomason/packer.nvim'}

    use {'morhetz/gruvbox'}
    use {'habamax/vim-gruvbit'}
    use {'mhinz/vim-startify'}
    use {'tpope/vim-fugitive'}
    use {'will133/vim-dirdiff'}
    use {'junegunn/gv.vim'}
    use {'tpope/vim-surround'}
    use {'tpope/vim-commentary'}
    use {'romainl/vim-qf'}
    use {'vimwiki/vimwiki', branch = 'dev'}
    use {'mbbill/undotree'}
    use {'kassio/neoterm'}
    use {'metakirby5/codi.vim'}
    use {'justinmk/vim-sneak'}
    use {'hrsh7th/vim-vsnip'}
    use {'Jorengarenar/vim-MvVis'}
    use {'skywind3000/asynctasks.vim'}
    use {'skywind3000/asyncrun.vim'}
    use {'GustavoKatel/telescope-asynctasks.nvim'}

    -- lua
    use {'neovim/nvim-lspconfig'}
    use {'nvim-treesitter/nvim-treesitter', branch = '0.5-compat'}
    use {'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    use {'nvim-telescope/telescope-project.nvim'}
    use {'hrsh7th/nvim-compe'}
    use {'ray-x/lsp_signature.nvim'}
    use {'mhartington/formatter.nvim'}
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
    use {'folke/twilight.nvim'}
    use {'folke/zen-mode.nvim'}
    use {'milisims/nvim-luaref'}
    use {'norcalli/nvim-colorizer.lua'}
    use {'akinsho/nvim-bufferline.lua'}
    use {'hoob3rt/lualine.nvim'}
    use {'kyazdani42/nvim-tree.lua',
      requires = {"kyazdani42/nvim-web-devicons"},
    }
    use {'simrat39/rust-tools.nvim',
      requires = {"neovim/nvim-lspconfig"},
    }
    use {'mfussenegger/nvim-jdtls'}

    use {
      'abecodes/tabout.nvim',
      config = function()
        require('tabout').setup {
        tabkey = '<Tab>',
        backwards_tabkey = '<S-Tab>',
        act_as_tab = true,
        act_as_shift_tab = true,
        enable_backwards = true,
        completion = false,
        tabouts = {
          {open = "'", close = "'"},
          {open = '"', close = '"'},
          {open = '`', close = '`'},
          {open = '(', close = ')'},
          {open = '[', close = ']'},
          {open = '{', close = '}'}
        },
        ignore_beginning = true,
        exclude = {}
        }
      end,
      wants = {'nvim-treesitter'},
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

