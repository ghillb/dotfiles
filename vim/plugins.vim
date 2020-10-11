" autoload plug
if empty(glob($NVC . '/autoload/plug.vim'))
  silent !curl -fLo $NVC/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if !has('nvim') | source $NVC/autoload/plug.vim | endif

call plug#begin($NVC . '/plugged')
Plug 'morhetz/gruvbox'
Plug 'habamax/vim-gruvbit'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'idanarye/vim-merginal'
Plug 'airblade/vim-gitgutter'
Plug 'will133/vim-dirdiff'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'benwainwright/fzf-project'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'unblevable/quick-scope'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/goyo.vim'
Plug 'mbbill/undotree'
Plug 'jiangmiao/auto-pairs'
Plug 'kassio/neoterm'
Plug 'voldikss/vim-floaterm'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'metakirby5/codi.vim'
Plug 'hashivim/vim-terraform'

if has('nvim-0.5')
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
    Plug 'nvim-lua/diagnostic-nvim'
    Plug 'nvim-treesitter/nvim-treesitter'
endif
call plug#end()

