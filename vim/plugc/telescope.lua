require("telescope").setup {
  defaults = {
    layout_config = {
      horizontal = { 
        preview_width = 0.6
      },
      center = { 
      },
      vertical = {
      }
    },
    mappings = {
      i = {
        ["<c-s>"] = require("telescope.actions").file_split,
        ["<esc>"] = require("telescope.actions").close,
      },
      n = {
        ["<c-s>"] = require("telescope.actions").file_split,
      }
    }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        }
      }
    }
  },
  extensions = {
    project = {
      base_dirs = {
        {'~/code', max_depth = 1}
      }
    }
  }
}

require'telescope'.load_extension('project')
