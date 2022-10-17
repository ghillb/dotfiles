local packer_opts = {
  "kassio/neoterm",
  config = function()
    vim.g.neoterm_default_mod = "belowright"
    vim.g.neoterm_autoscroll = true
    vim.g.neoterm_shell = "bash"
    vim.g.neoterm_eof = "\r"

    -- vim.keymap.set("n", "<a-r>", ":TREPLSendLine<cr>j")
    -- vim.keymap.set("v", "<a-r>", ":TREPLSendSelection<cr>")
  end,
}
return packer_opts
