let $VC = $HOME . '/.files/vim'
let $NVC = $HOME . '/.config/nvim'

luafile $VC/settings.lua
luafile $VC/plugins.lua
luafile $VC/functions.lua
luafile $VC/theme.lua
luafile $VC/file_types.lua
source $VC/mappings.vim

" plugin configs
luafile $VC/plugc/treesitter.lua
luafile $VC/plugc/codi.lua
luafile $VC/plugc/nvim-cmp.lua
luafile $VC/plugc/tabout.lua
luafile $VC/plugc/trouble.lua
luafile $VC/plugc/null_ls.lua
luafile $VC/plugc/vsnip.lua
luafile $VC/plugc/lsp_signature.lua
luafile $VC/plugc/lsp_installer.lua
luafile $VC/plugc/todo_comments.lua
luafile $VC/plugc/lightspeed.lua
luafile $VC/plugc/telescope.lua
luafile $VC/plugc/neoterm.lua
luafile $VC/plugc/alpha.lua
luafile $VC/plugc/bufferline.lua
luafile $VC/plugc/lualine.lua
luafile $VC/plugc/indent_line.lua
luafile $VC/plugc/gitsigns.lua
luafile $VC/plugc/diffview.lua
luafile $VC/plugc/twilight.lua
luafile $VC/plugc/zen_mode.lua
luafile $VC/plugc/qf_helper.lua
luafile $VC/plugc/autopairs.lua
luafile $VC/plugc/nvim-tree.lua
luafile $VC/plugc/nnn.lua
luafile $VC/plugc/mvvis.lua
luafile $VC/plugc/async_tasks.lua
luafile $VC/plugc/vimwiki.lua
lua vim.cmd('source ' .. vim.env.VC .. '/plugc/text-objects.vim')

