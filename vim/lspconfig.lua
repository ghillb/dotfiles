-- yaml-ls settings
local yamlls_settings = {
  yaml = {
    schemas = {
      ['https://json.schemastore.org/ansible-playbook'] = '*.pb.{yml,yaml}',
      ['http://json.schemastore.org/gitlab-ci'] = '*.gitlab-ci.{yml,yaml}',
      ['https://raw.githubusercontent.com/docker/cli/master/cli/compose/schema/data/config_schema_v3.9.json'] = '*.docker-compose.yml',
    },
    validate = true,
    hover = true,
    completion = true,
    format = {
      enable = true
    }
  }
}

-- rust-ls settings
local rust_analyzer_settings = {
  ["rust-analyzer"] = {
    server = {
      path = "~/.local/bin/rust-analyzer"
    };
    cargo = {
      allFeatures = true
    };
  }
}

local opts = {
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    runnables = {
      use_telescope = false
    },
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = "<-",
      other_hints_prefix  = "=>",
    },
  },
  server = {settings = rust_analyzer_settings},
}

require('rust-tools').setup(opts)

-- lsp setups
local has_lsp, nvim_lsp = pcall(require, 'lspconfig')
if has_lsp then
  nvim_lsp.bashls.setup{}
  nvim_lsp.vimls.setup{}
  nvim_lsp.jsonls.setup{}
  nvim_lsp.yamlls.setup{settings = yamlls_settings}
  nvim_lsp.dockerls.setup{}
  nvim_lsp.terraformls.setup{filetypes = {"tf"}}
  nvim_lsp.html.setup{}
  nvim_lsp.cssls.setup{}
  nvim_lsp.tsserver.setup{}
  nvim_lsp.pyright.setup{}
  nvim_lsp.r_language_server.setup{}
  nvim_lsp.gopls.setup{}
end

-- treesitter settings
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {},
  },
}

-- formatter settings
require('formatter').setup {
  logging = false,
  filetype = {
    python = {
      function()
        return {
          exe = "black",
          args = {"-"},
          stdin = true
        }
      end
    },
    javascript = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
          stdin = true
         }
       end
    },
    rust = {
      -- Rustfmt
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    },
    lua = {
      -- luafmt
      function()
        return {
          exe = "luafmt",
          args = {"--indent-count", 2, "--stdin"},
          stdin = true
        }
      end
    }
  }
}

-- trouble list settings
require("trouble").setup {
  use_lsp_diagnostic_signs = false,
  icons=false
}

-- todo comments settings
require("todo-comments").setup {
  signs = false,
  keywords = {
    FIX  = { color = "error", alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" } },
    TODO = { color = "info" },
    HACK = { color = "warning" },
    WARN = { color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { color = "hint", alt = { "INFO" } },
  },
  highlight = {
    before = "",
    keyword = "wide",
    after = "fg",
    pattern = [[.*<(KEYWORDS)\s*:]],
    comments_only = true,
  },
  colors = {
    error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
    warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
    info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
    hint = { "LspDiagnosticsDefaultHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
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

require "lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"},
    }
}
