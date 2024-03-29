local packer_opts = {
  "lewis6991/gitsigns.nvim",
  config = function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok then
      return
    end

    local config = {
      signs = {
        add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = { hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      },
      sign_priority = 1,
      numhl = false,
      linehl = false,
      diff_opts = {
        internal = true,
      },
      preview_config = {
        border = "none",
      },
    --   keymaps = {
    --     noremap = true,
    --     buffer = true,

    --     ["n ]h"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
    --     ["n [h"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },

    --     ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    --     ["v <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    --     ["n <leader>hS"] = "<cmd>Gwrite<CR>",
    --     ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    --     ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    --     ["v <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    --     ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    --     ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    --     ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line({full = true})<CR>',

    --     -- Text objects
    --     ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    --     ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    --   },
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      update_debounce = 100,
      status_formatter = nil,
      word_diff = false,
    }

    gitsigns.setup(config)
  end,
}
return packer_opts
