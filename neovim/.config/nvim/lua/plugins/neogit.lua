return function()
  local ok, neogit = pcall(require, "neogit")
  if not ok then
    return
  end

  neogit.setup({
    disable_signs = false,
    disable_hint = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = false,
    auto_refresh = true,
    sort_branches = "-committerdate",
    disable_builtin_notifications = false,
    use_magit_keybindings = false,
    kind = "tab",
    console_timeout = 2000,
    auto_show_console = true,
    commit_popup = {
      kind = "split",
    },
    signs = {
      section = { ">", "v" },
      item = { ">", "v" },
      hunk = { "", "" },
    },
    integrations = {
      diffview = true,
    },
    sections = {
      untracked = {
        folded = false,
        hidden = false
      },
      unstaged = {
        folded = false,
        hidden = false
      },
      staged = {
        folded = false,
        hidden = false
      },
      stashes = {
        folded = true,
        hidden = false
      },
      unpulled = {
        folded = true,
        hidden = false
      },
      unmerged = {
        folded = false,
        hidden = false
      },
      recent = {
        folded = true,
        hidden = false
      },
    },
  })

  vim.keymap.set("n", "<a-g>", "<cmd>Neogit<cr>", { desc = "Neogit status" })
  
  -- Add Ctrl+Q to quit Neovim entirely when in Neogit buffer
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "NeogitStatus",
    callback = function()
      vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>", { buffer = true, desc = "Quit Neovim" })
    end,
  })
end