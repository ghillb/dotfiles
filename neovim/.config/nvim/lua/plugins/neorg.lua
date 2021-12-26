local ok, neorg = pcall(require, 'neorg')
if not ok then return end

neorg.setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.concealer"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          my_workspace = "~/neorg"
        },
        autodetect = true,
        autochdir = true,
      },
    },
    ["core.keybinds"] = {
      config = {
        default_keybinds = true,
        neorg_leader = "<leader>n"
      }
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp"
      }
    }
  },
}
