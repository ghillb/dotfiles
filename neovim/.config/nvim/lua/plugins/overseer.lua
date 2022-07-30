local packer_opts = {
  "stevearc/overseer.nvim",
  config = function()
    local ok, overseer = pcall(require, "overseer")
    if not ok then
      return
    end
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
        direction = "left",
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
        border = "rounded",
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

    -- overseer.new_task({
    --   name = "Example Task",
    --   strategy = {
    --     "orchestrator",
    --     tasks = {
    --       { "shell", cmd = "ls" },
    --       {
    --         { "shell", cmd = "pwd" },
    --         { "shell", cmd = "ls -a" },
    --       },
    --       { "shell", cmd = "echo 'HURRA'" },
    --     },
    --   },
    -- })

    overseer.register_template({
      name = "Compile C++",
      builder = function(params)
        return {
          cmd = {
            "g++",
            "-o",
            string.format("%s.out", vim.api.nvim_buf_get_name(0)),
            vim.api.nvim_buf_get_name(0),
          },
        }
      end,
      tags = { overseer.TAG.BUILD },
      params = {},
      priority = 50,
      condition = {
        filetype = { "c", "cpp" },
      },
    })

    overseer.register_template({
      name = "Run Binary",
      builder = function(params)
        return {
          cmd = {
            string.format("%s.%s", vim.api.nvim_buf_get_name(0), params.extension),
          },
        }
      end,
      tags = { overseer.TAG.BUILD },
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
  end,
}
return packer_opts
