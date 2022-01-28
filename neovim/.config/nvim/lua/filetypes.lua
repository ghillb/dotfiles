-- TODO: retire this file and "nathom/filetype.nvim" in nvim 0.8
require("filetype").setup({
  overrides = {
    extensions = {
      tf = "terraform",
    },
    literal = {},
    complex = {
      [".*.gitlab.*.yml"] = "gitlab-ci",
      [".*docker.compose.*.yml"] = "docker-compose",
    },

    function_extensions = {},
    function_literal = {},
    function_complex = {},
  },
})
