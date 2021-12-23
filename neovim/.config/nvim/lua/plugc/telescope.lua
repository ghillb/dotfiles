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
      theme = "dropdown",
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
telescope.load_extension("frecency")
telescope.load_extension("cheat")

-- telescope mappings
local nnoremap = vim.keymap.nnoremap
local builtin = require("telescope.builtin")

nnoremap({ "<c-e>", builtin.find_files })
nnoremap({ "<c-a-e>", TelescopeOmniFiles })
nnoremap({ "<c-p>", builtin.live_grep })
nnoremap({ "<c-b>", builtin.buffers })
nnoremap({ "<c-\\>", builtin.current_buffer_fuzzy_find })
nnoremap({ "<c-g>", SwitchGitBranch })
nnoremap({ "<leader>fg", builtin.git_status })
nnoremap({ "<leader>fk", builtin.keymaps })
nnoremap({ "<leader>fc", builtin.commands })
nnoremap({ "<leader>fm", builtin.man_pages })
nnoremap({ "<leader>fh", builtin.help_tags })
nnoremap({ "<leader>fq", builtin.quickfix })
nnoremap({ "<leader>fl", builtin.loclist })
nnoremap({ "<leader>ff", telescope.extensions.frecency.frecency })
nnoremap({ "<leader>ft", telescope.extensions.asynctasks.all })
nnoremap({ "<leader>fy", telescope.extensions.neoclip.default})
nnoremap({ "<leader>fz", ":Telescope cheat fd<cr>" })
nnoremap({
  "<esc><esc>",
  function()
    telescope.extensions.project.project({ display_type = "full" })
  end,
})
