local packer_opts = {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({ ignore = "^$" })
    local ft = require("Comment.ft")
    local comment_strings = { "#%s", "#%s" }
    ft.set("gitlab-ci", comment_strings).set("ansible", comment_strings).set("docker-compose", comment_strings)
  end,
}
return packer_opts
