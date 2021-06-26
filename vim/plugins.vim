if empty(glob($NVC . '/pack/minpac/opt/minpac/autoload/minpac.vim')) && has('unix') && has('nvim')
  !git clone https://github.com/k-takata/minpac.git $NVC/pack/minpac/opt/minpac
elseif empty(glob('~/.vim/pack/minpac/opt/minpac')) && has('unix') && !has('nvim')
  !git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
endif

silent! packadd minpac

if !exists('g:loaded_minpac')
  echo "minpac not available"
else
  call minpac#init({'verbose': 3})

  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('ghillb/gruvbox')
  call minpac#add('habamax/vim-gruvbit')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('mhinz/vim-startify')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('idanarye/vim-merginal')
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('will133/vim-dirdiff')
  call minpac#add('junegunn/gv.vim')
  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('ghillb/fzf-project')
  call minpac#add('stsewd/fzf-checkout.vim')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('romainl/vim-qf')
  call minpac#add('machakann/vim-highlightedyank')
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
    call minpac#add('mhartington/formatter.nvim') 
    call minpac#add('folke/trouble.nvim')
    call minpac#add('folke/todo-comments.nvim')
    call minpac#add('folke/which-key.nvim')
    call minpac#add('simrat39/rust-tools.nvim')
    call minpac#add('mfussenegger/nvim-jdtls')
    call minpac#add('milisims/nvim-luaref')
    call minpac#add('akinsho/nvim-bufferline.lua')
  endif

  command! PUpdate source $MYVIMRC | call minpac#update()
  command! PClean source $MYVIMRC | call minpac#clean()
  command! PStatus call minpac#status()
endif

