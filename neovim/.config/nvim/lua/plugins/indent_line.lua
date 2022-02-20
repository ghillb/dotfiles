vim.g.indent_blankline_enabled = false
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_first_indent_level = false
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_filetype_exclude = {
  "alpha",
  "fugitive",
  "vimwiki",
  "packer",
  "copy-mode",
  "help",
  "neoterm",
  "lsp-installer",
  "",
}
vim.g.indent_blankline_show_trailing_blankline_indent = false

require("indent_blankline").setup({
  space_char_blankline = " ",
  show_current_context = false,
  show_current_context_start = false,
})
