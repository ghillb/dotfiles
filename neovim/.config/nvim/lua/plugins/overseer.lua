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
      actions = {
        ["open tab"] = {
          desc = "open terminal in a new brackground tab",
          condition = function(task)
            local bufnr = task:get_bufnr()
            return bufnr and vim.api.nvim_buf_is_valid(bufnr)
          end,
          run = function(task)
            local t = vim.api.nvim_get_current_tabpage()
            vim.cmd([[tabnew]])
            vim.api.nvim_win_set_buf(0, task:get_bufnr())
            vim.api.nvim_set_current_tabpage(t)
          end,
        },
        ["open hsplit, no focus"] = {
          desc = "open terminal in a horizontal split",
          condition = function(task)
            local bufnr = task:get_bufnr()
            return bufnr and vim.api.nvim_buf_is_valid(bufnr)
          end,
          run = function(task)
            vim.cmd([[split]])
            vim.api.nvim_win_set_buf(0, task:get_bufnr())
            vim.cmd([[wincmd k]])
          end,
        },
      },
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

    overseer.register_template({
      name = "AWS: Change instance state",
      builder = function(params)
        return {
          cmd = {
            "aws",
            "ec2",
            string.format("%s-instances", params.action),
            "--instance-ids",
            params.instance_id,
          },
        }
      end,
      params = {
        action = {
          type = "enum",
          name = "Action",
          optional = false,
          choices = {
            "start",
            "stop",
          },
        },
        instance_id = {
          type = "string",
          name = "Instance ID",
          optional = false,
          default = vim.env.AWS_INSTANCE_ID,
        },
      },
      priority = 1000,
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
