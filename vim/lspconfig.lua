-- settings for various lsp
local yamlls_settings = {
  yaml = {
    schemas = {
      ['https://json.schemastore.org/ansible-playbook'] = '*-pb.{yml,yaml}',
      ['http://json.schemastore.org/gitlab-ci'] = '*.gitlab-ci.{yml,yaml}',
      ['https://raw.githubusercontent.com/docker/cli/master/cli/compose/schema/data/config_schema_v3.9.json'] = '*docker-compose.yml',
    },
    validate = true,
    hover = true,
    completion = true,
    format = {
      enable = true
    }
  }
}

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

-- lsp attaching
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
  nvim_lsp.rust_analyzer.setup{settings = rust_analyzer_settings}
  nvim_lsp.jdtls.setup{}
end

-- treesitter settings
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {},
  },
}

