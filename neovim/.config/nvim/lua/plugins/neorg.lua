local packer_opts = {
  "nvim-neorg/neorg",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    if vim.env.NVIM_INIT then return end
    local neorg = require("neorg")

    neorg.setup({
      load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
          config = {
            workspaces = {
              my_workspace = "~/neorg",
            },
            autodetect = true,
            autochdir = true,
          },
        },
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<leader>n",
          },
        },
        ["core.norg.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
      },
    })
  end,
}
return packer_opts
