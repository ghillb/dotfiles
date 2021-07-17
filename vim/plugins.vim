let $NVC = $HOME . '/.config/nvim'
if empty(glob($NVC . '/pack/minpac/opt/minpac/autoload/minpac.vim')) && has('unix') && has('nvim')
  silent !git clone https://github.com/k-takata/minpac.git $NVC/pack/minpac/opt/minpac
endif

silent! packadd minpac

if !exists('g:loaded_minpac')
  echo "minpac not available"
else
  call minpac#init({'verbose': 3})

  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('morhetz/gruvbox')
  call minpac#add('habamax/vim-gruvbit')
  call minpac#add('mhinz/vim-startify')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('will133/vim-dirdiff')
  call minpac#add('junegunn/gv.vim')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('romainl/vim-qf')
  call minpac#add('vimwiki/vimwiki', { 'branch': 'dev' })
  call minpac#add('junegunn/goyo.vim')
  call minpac#add('junegunn/limelight.vim')
  call minpac#add('mbbill/undotree')
  call minpac#add('jiangmiao/auto-pairs')
  call minpac#add('kassio/neoterm')
  call minpac#add('lambdalisue/fern.vim')
  call minpac#add('lambdalisue/fern-hijack.vim')
  call minpac#add('lambdalisue/fern-git-status.vim')
  call minpac#add('metakirby5/codi.vim')
  call minpac#add('justinmk/vim-sneak')
  call minpac#add('hrsh7th/vim-vsnip')
  call minpac#add('Yggdroot/indentLine')
  call minpac#add('Jorengarenar/vim-MvVis')
  call minpac#add('norcalli/nvim-colorizer.lua')

  if has('nvim-0.5')
    call minpac#add('neovim/nvim-lspconfig')
    call minpac#add('nvim-treesitter/nvim-treesitter')
    call minpac#add('hrsh7th/nvim-compe')
    call minpac#add('ray-x/lsp_signature.nvim')
    call minpac#add('mhartington/formatter.nvim') 
    call minpac#add('folke/trouble.nvim')
    call minpac#add('folke/todo-comments.nvim')
    call minpac#add('folke/which-key.nvim')
    call minpac#add('simrat39/rust-tools.nvim')
    call minpac#add('mfussenegger/nvim-jdtls')
    call minpac#add('milisims/nvim-luaref')
    call minpac#add('akinsho/nvim-bufferline.lua')
    call minpac#add('hoob3rt/lualine.nvim')
    call minpac#add('kyazdani42/nvim-web-devicons')
    call minpac#add('nvim-lua/popup.nvim')
    call minpac#add('nvim-lua/plenary.nvim')
    call minpac#add('nvim-telescope/telescope.nvim')
    call minpac#add('nvim-telescope/telescope-project.nvim')
    call minpac#add('lewis6991/gitsigns.nvim')
  endif

  command! PUpdate source $MYVIMRC | call minpac#update()
  command! PClean source $MYVIMRC | call minpac#clean()
  command! PStatus call minpac#status()
  command! PUpdateAndQuit  call minpac#update('', {'do': 'call timer_start(20000, { tid -> execute("quit | quit")})'})
endif

