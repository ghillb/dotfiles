-- settings for various lsp
local yamlls_settings = {
  yaml = {
    schemas = {
      ['https://json.schemastore.org/ansible-playbook'] = '*-pb.{yml,yaml}',
      ['http://json.schemastore.org/gitlab-ci'] = '*.gitlab-ci.{yml,yaml}',
    },
    validate = true,
    hover = true,
    completion = true,
    format = {
      enable = true
    }
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
  nvim_lsp.rust_analyzer.setup{}
end

-- treesitter settings
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {},
  },
}

