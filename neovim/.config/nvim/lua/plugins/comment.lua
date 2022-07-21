local packer_opts = {
  "numToStr/Comment.nvim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local ok, comment = pcall(require, "Comment")
    if not ok then
      return
    end

    local config = {
      ignore = "^$",
    }

    comment.setup(config)
  end,
}
return packer_opts
