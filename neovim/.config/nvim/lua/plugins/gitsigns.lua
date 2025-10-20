return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  opts = {
    signs = {
      add          = { text = '│' },
      change       = { text = '│' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      enable = true,
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']h', gs.next_hunk, {desc = "Next hunk"})
      map('n', '[h', gs.prev_hunk, {desc = "Previous hunk"})

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage hunk" })
      map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset hunk" })
      map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage hunk" })
      map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset hunk" })
      map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage buffer" })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo stage hunk" })
      map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer" })
      map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
      map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = "Blame line" })
      map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle line blame" })
      map('n', '<leader>hd', gs.diffthis, { desc = "Diff this" })
      map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff this ~" })
      map('n', '<leader>td', gs.toggle_deleted, { desc = "Toggle deleted" })

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select hunk" })
    end
  },
}
