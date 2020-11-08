if empty(glob($NVC . '/pack/minpac/opt/minpac/autoload/minpac.vim')) && has('unix') && has('nvim')
    !git clone https://github.com/k-takata/minpac.git $NVC/pack/minpac/opt/minpac
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
    call minpac#add('junegunn/fzf')
    call minpac#add('junegunn/fzf.vim')
    call minpac#add('benwainwright/fzf-project')
    call minpac#add('tpope/vim-surround')
    call minpac#add('tpope/vim-commentary')
    call minpac#add('machakann/vim-highlightedyank')
    call minpac#add('vimwiki/vimwiki', { 'branch': 'dev' })
    call minpac#add('unblevable/quick-scope')
    call minpac#add('junegunn/vim-peekaboo')
    call minpac#add('junegunn/goyo.vim')
    call minpac#add('mbbill/undotree')
    call minpac#add('jiangmiao/auto-pairs')
    call minpac#add('kassio/neoterm')
    call minpac#add('voldikss/vim-floaterm')
    call minpac#add('lambdalisue/fern.vim')
    call minpac#add('lambdalisue/fern-git-status.vim')
    call minpac#add('liuchengxu/vim-which-key')
    call minpac#add('metakirby5/codi.vim')
    call minpac#add('hashivim/vim-terraform')
    call minpac#add('justinmk/vim-sneak')
    call minpac#add('ConradIrwin/vim-bracketed-paste')
    call minpac#add('sirver/ultisnips')

    if has('nvim-0.5')
        call minpac#add('neovim/nvim-lspconfig')
        call minpac#add('nvim-lua/completion-nvim')
        call minpac#add('nvim-lua/diagnostic-nvim')
        call minpac#add('nvim-treesitter/nvim-treesitter')
    endif

    command! PackUpdate source $MYVIMRC | call minpac#update()
    command! PackClean source $MYVIMRC | call minpac#clean()
    command! PackStatus call minpac#status()
endif

