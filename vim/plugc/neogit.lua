local neogit = require('neogit')

neogit.setup {
  disable_signs = false,
  disable_context_highlighting = true,
  disable_commit_confirmation = false,
  signs = {
    section = { ">", "v" },
    item = { ">", "v" },
    hunk = { "", "" },
  },
  integrations = {
    diffview = true
  }
}

