" autoload plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'habamax/vim-gruvbit'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'idanarye/vim-merginal'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'unblevable/quick-scope'
Plug 'junegunn/vim-peekaboo'
Plug 'mbbill/undotree'
Plug 'jiangmiao/auto-pairs'
Plug 'kassio/neoterm'
Plug 'voldikss/vim-floaterm'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'mhinz/vim-startify'
Plug 'benwainwright/fzf-project'
Plug 'metakirby5/codi.vim'
call plug#end()

