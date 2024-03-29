local packer_opts = {
  "vimwiki/vimwiki",
  config = function()
    vim.g.vimwiki_list = {
      {
        path = "~/.notes/",
        syntax = "markdown",
        ext = ".md",
        template_path = "~/.notes/templates/",
        template_default = "default",
        path_html = "~/.notes/html/",
        custom_wiki2html = "vimwiki_markdown",
        template_ext = ".tpl",
        nested_syntaxes = {
          cpp = "cpp",
          python = "python",
          java = "java",
          js = "javascript",
          html = "html",
          css = "css",
        },
      },
    }

    vim.g.vimwiki_table_mappings = 0
    vim.g.vimwiki_markdown_link_ext = 0
    vim.g.vimwiki_global_ext = 0
  end,
}
return packer_opts
