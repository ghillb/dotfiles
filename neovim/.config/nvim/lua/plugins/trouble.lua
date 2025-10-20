return {
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleToggle" },
  keys = {
    { "<leader>tt", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
    { "<a-bs>", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Toggle document diagnostics" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    use_diagnostic_signs = true,
    icons = false,
  },
}
