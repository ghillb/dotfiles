local packer_opts = {
  "akinsho/git-conflict.nvim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local ok, git_conflict = pcall(require, "git-conflict")
    if not ok then
      return
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "GitConflictDetected",
      callback = function()
        vim.notify("Git conflict detected!")
        vim.keymap.set("n", "co", "<Plug>(git-conflict-ours)")
        vim.keymap.set("n", "ct", "<Plug>(git-conflict-theirs)")
        vim.keymap.set("n", "cb", "<Plug>(git-conflict-both)")
        vim.keymap.set("n", "cd", "<Plug>(git-conflict-none)")
        vim.keymap.set("n", "[c", "<Plug>(git-conflict-prev-conflict)")
        vim.keymap.set("n", "]c", "<Plug>(git-conflict-next-conflict)")
      end,
    })

    local config = {
      {
        default_mappings = false,
        disable_diagnostics = false,
        highlights = {
          incoming = "DiffAdd",
          current = "DiffText",
        },
      },
    }

    git_conflict.setup(config)
  end,
}
return packer_opts
