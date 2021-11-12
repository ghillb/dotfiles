vim.g.did_load_filetypes = 1
require('filetype').setup({
  overrides = {
    extensions = {
    },
    literal = {
    },
    complex = {
      [".*gitlab.*yml"] = "gitlab-ci",
    },

    function_extensions = {
    },
    function_literal = {
    },
    function_complex = {
    },
  }
})

