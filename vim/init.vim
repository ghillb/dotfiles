let $VC = $HOME . '/.files/vim'
let $NVC = $HOME . '/.config/nvim'

source $VC/settings.vim
luafile $VC/plugins.lua
luafile $VC/functions.lua
source $VC/functions.vim
source $VC/theme.vim
source $VC/mappings.vim
source $VC/file_types.vim

" plugin configs
source $VC/plugc/vimwiki.vim
source $VC/plugc/sneak.vim
source $VC/plugc/netrw.vim
source $VC/plugc/startify.vim
source $VC/plugc/codi.vim
source $VC/plugc/vsnip.vim
source $VC/plugc/vimqf.vim
source $VC/plugc/text-objects.vim
source $VC/plugc/myvis.vim

luafile $VC/lspconfig.lua
luafile $VC/plugc/treesitter.lua
luafile $VC/plugc/nvim-compe.lua
luafile $VC/plugc/trouble.lua
luafile $VC/plugc/formatter.lua
luafile $VC/plugc/lsp_signature.lua
luafile $VC/plugc/rust_tools.lua
luafile $VC/plugc/todo_comments.lua
luafile $VC/plugc/telescope.lua
luafile $VC/plugc/neoterm.lua
luafile $VC/plugc/bufferline.lua
luafile $VC/plugc/lualine.lua
luafile $VC/plugc/indent_line.lua
luafile $VC/plugc/gitsigns.lua
luafile $VC/plugc/diffview.lua
luafile $VC/plugc/twilight.lua
luafile $VC/plugc/zen_mode.lua
luafile $VC/plugc/autopairs.lua
luafile $VC/plugc/nvim-tree.lua
luafile $VC/plugc/nnn.lua
luafile $VC/plugc/async_tasks.lua
lua local ok, cz = pcall(require, 'colorizer') if ok then cz.setup() end

