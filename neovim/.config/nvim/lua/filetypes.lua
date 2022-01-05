-- this file and "nathom/filetype.nvim" can be retired in nvim 0.8
require("filetype").setup({
  overrides = {
    extensions = {
      tf = "terraform",
    },
    literal = {},
    complex = {
      [".*.gitlab.*.yml"] = "gitlab-ci",
      [".*docker.compose.*"] = "docker-compose",
    },

    function_extensions = {},
    function_literal = {},
    function_complex = {},
  },
})
