local packer_opts = {
  "stevearc/overseer.nvim",
  config = function()
    local ok, overseer = pcall(require, "overseer")
    if not ok then
      return
    end

    _G.overseer_config = { run = {}, test = {}, build = {} }

    local e = vim.fn.expand

    overseer.setup({
      strategy = "terminal",
      templates = { "builtin" },
      auto_detect_success_color = true,
      dap = true,
      task_list = {
        default_detail = 1,
        max_width = { 100, 0.2 },
        min_width = { 40, 0.1 },
        separator = "────────────────────────────────────────",
        direction = "right",
        bindings = {
          ["?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-f>"] = "OpenFloat",
          ["p"] = "TogglePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
        },
      },
      actions = {},
      form = {
        border = "none",
        zindex = 40,
        min_width = 80,
        max_width = 0.9,
        min_height = 10,
        max_height = 0.9,
        win_opts = {
          winblend = 10,
        },
      },
      task_launcher = {
        bindings = {
          i = {
            ["<C-s>"] = "Submit",
          },
          n = {
            ["<CR>"] = "Submit",
            ["<C-s>"] = "Submit",
            ["?"] = "ShowHelp",
          },
        },
      },
      task_editor = {
        bindings = {
          i = {
            ["<CR>"] = "NextOrSubmit",
            ["<C-s>"] = "Submit",
            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",
          },
          n = {
            ["<CR>"] = "NextOrSubmit",
            ["<C-s>"] = "Submit",
            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",
            ["?"] = "ShowHelp",
          },
        },
      },
      confirm = {
        border = "rounded",
        zindex = 40,
        min_width = 80,
        max_width = 0.5,
        min_height = 10,
        max_height = 0.9,
        win_opts = {
          winblend = 10,
        },
      },
      task_win = {
        padding = 2,
        border = "rounded",
        win_opts = {
          winblend = 10,
        },
      },
      -- Aliases for bundles of components. Redefine the builtins, or create your own.
      component_aliases = {
        -- Most tasks are initialized with the default components
        default = {
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "on_complete_dispose",
        },
      },
      pre_task_hook = function(task_defn, util) end,
      preload_components = {},
      log = {
        {
          type = "echo",
          level = vim.log.levels.WARN,
        },
        {
          type = "file",
          filename = "overseer.log",
          level = vim.log.levels.WARN,
        },
      },
    })

    overseer.register_template({
      name = "Run binary",
      builder = function(params)
        return {
          cmd = {
            string.format("%s.%s", e("%:p:r"), params.extension),
          },
        }
      end,
      params = {
        extension = {
          type = "string",
          name = "Extension",
          optional = true,
          default = "out",
        },
      },
      priority = 50,
      condition = {
        filetype = { "c", "cpp" },
      },
    })

    vim.keymap.set("n", "<a-bs>", ":OverseerToggle<cr>")
    vim.keymap.set("n", "<a-s-r>", function()
      _G.overseer_config.run[vim.bo.filetype]()
    end)

    vim.keymap.set("n", "<a-s-t>", function()
      _G.overseer_config.test[vim.bo.filetype]()
    end)
    vim.keymap.set("n", "<a-s-b>", function()
      _G.overseer_config.build[vim.bo.filetype]()
    end)
    vim.keymap.set("n", "<a-s-p>", function()
      _G.overseer_config.project()
    end)
  end,
}
return packer_opts
