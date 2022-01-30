local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local actions = require("telescope.actions")

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
    path_display = { "shorten" },
    dynamic_preview_title = true,
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
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
    },
    live_grep = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "-g",
        "!.git/",
      },
    },
    lsp_code_actions = {
      layout_config = { width = 80, height = 10 },
    },
  },
  extensions = {
    project = {
      base_dirs = {
        { vim.env.CODE },
        { vim.env.DOTFILES },
      },
      hidden_files = true,
    },
  },
}

telescope.setup(config)
telescope.load_extension("project")
telescope.load_extension("dap")
telescope.load_extension("frecency")
telescope.load_extension("cheat")

-- telescope mappings
local map = vim.keymap.set
local builtin = require("telescope.builtin")

map('n', "<c-e>", builtin.find_files)
map('n', "<c-a-e>", TelescopeOmniFiles)
map('n', "<c-p>", builtin.live_grep)
map('n', "<c-b>", builtin.buffers)
map('n', "<c-_>", builtin.current_buffer_fuzzy_find)
map('n', "<c-g>", SwitchGitBranch)
map('n', "<leader>fg", builtin.git_status)
map('n', "<leader>fk", builtin.keymaps)
map('n', "<leader>fc", builtin.commands)
map('n', "<leader>fm", builtin.man_pages)
map('n', "<leader>fh", builtin.help_tags)
map('n', "<leader>fq", builtin.quickfix)
map('n', "<leader>fl", builtin.loclist)
map('n', "<leader>ff", telescope.extensions.frecency.frecency)
map('n', "<leader>ft", telescope.extensions.asynctasks.all)
map('n', "<leader>fy", telescope.extensions.neoclip.default)
map('n', "<leader>fz", ":Telescope cheat fd<cr>")
map('n', "<esc><esc>", function() telescope.extensions.project.project({ display_type = "full" }) end)
