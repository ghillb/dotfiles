local packer_opts = {
  "nvim-telescope/telescope.nvim",
  requires = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-project.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "nvim-telescope/telescope-rg.nvim" },
    { "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" } },
    { "nvim-telescope/telescope-cheat.nvim", requires = { "tami5/sqlite.lua" } },
    { "GustavoKatel/telescope-asynctasks.nvim" },
  },
  config = function()
    local ok, telescope = pcall(require, "telescope")
    if not ok then
      return
    end

    local actions = require("telescope.actions")
    local rg_config = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob",
      "!.git/",
    }

    local borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }

    local config = {
      defaults = {
        layout_config = {
          bottom_pane = {
            height = 25,
            prompt_position = "top",
          },
          center = {
            height = 0.9,
            preview_cutoff = 40,
            prompt_position = "top",
            width = 0.8,
          },
          cursor = {
            height = 0.9,
            preview_cutoff = 40,
            width = 0.8,
          },
          horizontal = {
            height = 0.9,
            preview_cutoff = 120,
            prompt_position = "bottom",
            width = 0.8,
            preview_width = 0.5,
          },
          vertical = {
            height = 0.9,
            preview_cutoff = 40,
            prompt_position = "bottom",
            width = 0.8,
          },
        },
        path_display = { "smart" },
        dynamic_preview_title = true,
        borderchars = borderchars,
        mappings = {
          i = {
            ["<c-s>"] = actions.file_split,
            ["<c-h>"] = actions.which_key,
            ["<c-w>"] = actions.send_selected_to_qflist,
            ["<c-q>"] = actions.send_to_qflist,
          },
          n = {
            ["<c-s>"] = actions.file_split,
            ["<c-h>"] = actions.which_key,
            ["<c-w>"] = actions.send_selected_to_qflist,
            ["<c-q>"] = actions.send_to_qflist,
          },
        },
      },
      pickers = {
        buffers = {
          sort_lastused = true,
          layout_config = { width = 80, height = 15 },
          previewer = false,
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
            },
            n = {
              ["<c-d>"] = actions.delete_buffer,
            },
          },
        },
        find_files = {
          hidden = true,
          file_ignore_patterns = {
            ".git/",
          },
          prompt_title = "Files",
        },
        live_grep = {
          vimgrep_arguments = rg_config,
        },
      },
      extensions = {
        project = {
          base_dirs = {
            { "~/code" },
            { "~/.files" },
          },
          hidden_files = true,
        },
        ["ui-select"] = {
          require("telescope.themes").get_ivy({
            layout_config = { width = 80, height = 10 },
            borderchars = borderchars,
          }),
        },
      },
    }

    telescope.setup(config)
    telescope.load_extension("project")
    telescope.load_extension("ui-select")
    telescope.load_extension("dap")
    telescope.load_extension("frecency")
    telescope.load_extension("cheat")
    telescope.load_extension("live_grep_raw")

    -- telescope mappings
    local map = vim.keymap.set
    local builtin = require("telescope.builtin")

    map({ "n", "v" }, "<c-h>", builtin.resume)
    map({ "n", "v" }, "<c-e>", builtin.find_files)
    map({ "n", "v" }, "<c-a-e>", TelescopeOmniFiles)
    map({ "n", "v" }, "<c-p>", function()
      telescope.extensions.live_grep_raw.live_grep_raw({
        vimgrep_arguments = rg_config,
        prompt_title = "Grep",
      })
    end)
    map({ "n", "v" }, "<c-b>", builtin.buffers)
    map({ "n", "v" }, "<c-_>", builtin.current_buffer_fuzzy_find)
    map({ "n", "v" }, "<c-g>", builtin.git_status)
    map("n", "<leader>fg", SwitchGitBranch)
    map("n", "<leader>fp", builtin.builtin)
    map("n", "<leader>fk", builtin.keymaps)
    map("n", "<leader>fc", builtin.commands)
    map("n", "<leader>fm", builtin.man_pages)
    map("n", "<leader>fh", builtin.help_tags)
    map("n", "<leader>fq", builtin.quickfix)
    map("n", "<leader>fl", builtin.loclist)
    map("n", "<leader>ff", telescope.extensions.frecency.frecency)
    map("n", "<leader>ft", telescope.extensions.asynctasks.all)
    map("n", "<leader>fy", telescope.extensions.neoclip.plus)
    map("n", "<leader>fz", ":Telescope cheat fd<cr>")
    map("n", "<esc><esc>", function()
      telescope.extensions.project.project({ display_type = "full" })
    end)
  end,
}
return packer_opts
