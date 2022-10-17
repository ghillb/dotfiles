local packer_opts = {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    local ok, indent_blankline = pcall(require, "indent_blankline")
    if not ok then
      return
    end

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

    local config = {
      space_char_blankline = " ",
      show_current_context = false,
      show_current_context_start = false,
    }

    indent_blankline.setup(config)
  end,
}
return packer_opts
