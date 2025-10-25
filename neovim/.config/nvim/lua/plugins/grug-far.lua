return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  keys = {
    { "<leader>sr", mode = { "n", "v" } },
  },
  config = function()
    local grug_far = require("grug-far")

    grug_far.setup({
      -- Optional: configure debounce for automatic search
      -- startInInsertMode = true,
      -- debounceMs = 500,
    })

    -- Keybindings
    vim.keymap.set("n", "<leader>sr", function()
      grug_far.open({ prefills = { search = vim.fn.expand("<cword>") } })
    end, { desc = "Search and replace (word under cursor)" })

    vim.keymap.set("v", "<leader>sr", function()
      grug_far.with_visual_selection({ prefills = { search = vim.fn.expand("<cword>") } })
    end, { desc = "Search and replace (visual selection)" })
  end,
}
