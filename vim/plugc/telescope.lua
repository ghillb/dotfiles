require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<c-s>"] = require("telescope.actions").file_split,
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
    },
    git_files = {
      theme = "dropdown"
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
