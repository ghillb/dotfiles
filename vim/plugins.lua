local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

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

    -- lua
    use {'neovim/nvim-lspconfig'}
    use {'nvim-treesitter/nvim-treesitter', branch = '0.5-compat'}
    use {'hrsh7th/nvim-compe'}
    use {'ray-x/lsp_signature.nvim'}
    use {'mhartington/formatter.nvim'}
    use {'folke/trouble.nvim'}
    use {'folke/todo-comments.nvim'}
    use {'folke/which-key.nvim'}
    use {'simrat39/rust-tools.nvim'}
    use {'mfussenegger/nvim-jdtls'}
    use {'milisims/nvim-luaref'}
    use {'norcalli/nvim-colorizer.lua'}
    use {'akinsho/nvim-bufferline.lua'}
    use {'hoob3rt/lualine.nvim'}
    use {'kyazdani42/nvim-tree.lua'}
    use {'kyazdani42/nvim-web-devicons'}
    use {'nvim-lua/popup.nvim'}
    use {'nvim-lua/plenary.nvim'}
    use {'nvim-telescope/telescope.nvim'}
    use {'nvim-telescope/telescope-project.nvim'}
    use {'lewis6991/gitsigns.nvim'}
    use {'lukas-reineke/indent-blankline.nvim'}
    use {'folke/twilight.nvim'}
    use {'folke/zen-mode.nvim'}
    use {'windwp/nvim-autopairs'}

  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})

