local packer_opts = {
  "folke/todo-comments.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    local ok, todo_comments = pcall(require, "todo-comments")
    if not ok then
      return
    end
    -- examples:
    -- TODO:
    -- WARN:
    -- HACK:
    -- FIXME:
    -- OPTIMIZE:
    -- NOTE:

    local config = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
      merge_keywords = true,
      highlight = {
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      colors = {
        error = { "DiagnosticError" },
        warning = { "DiagnosticWarn", "#FBBF24" },
        info = { "#10B981" },
        hint = { "#7C3AED" },
        default = { "Identifier" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]],
      },
    }

    todo_comments.setup(config)
  end,
}
return packer_opts
