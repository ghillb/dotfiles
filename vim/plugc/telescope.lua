local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end

local actions = require('telescope.actions')

local config = {
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
        ["<c-s>"] = actions.file_split,
        ["<esc>"] = actions.close,
      },
      n = {
        ["<c-s>"] = actions.file_split,
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
          ["<c-d>"] = actions.delete_buffer,
        },
        n = {
          ["<c-d>"] = actions.delete_buffer,
        }
      }
    }
  },
  extensions = {
    project = {
      base_dirs = {
        {'~/code'},
        {'~/.files'},
        {'~/scripts'},
      }
    }
  }
}

telescope.setup(config)
telescope.load_extension('project')

