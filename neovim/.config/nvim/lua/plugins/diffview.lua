return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local actions = require("diffview.actions")
    local function close_diffview()
      require("diffview").close()
    end

    require("diffview").setup({
      keymaps = {
        view = {
          { "n", "q", close_diffview, { desc = "Close Diffview" } },
        },
        file_panel = {
          { "n", "q", close_diffview, { desc = "Close Diffview" } },
          { "n", "<C-d>", actions.scroll_view(0.5), { desc = "Scroll the diff down half a page" } },
          { "n", "<C-u>", actions.scroll_view(-0.5), { desc = "Scroll the diff up half a page" } },
        },
      },
    })
  end,
}
