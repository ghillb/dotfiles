-- settings for various lsp
local yamlls_settings = {
  yaml = {
    schemas = {
      ['https://json.schemastore.org/ansible-playbook'] = '*-pb.{yml,yaml}',
      ['http://json.schemastore.org/gitlab-ci'] = '.gitlab-ci.{yml,yaml}',
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
  nvim_lsp.bashls.setup{on_attach = on_attach_lsp}
  nvim_lsp.vimls.setup{on_attach = on_attach_lsp}
  nvim_lsp.jsonls.setup{on_attach = on_attach_lsp}
  nvim_lsp.yamlls.setup{settings = yamlls_settings, on_attach = on_attach }
  nvim_lsp.dockerls.setup{on_attach = on_attach_lsp}
  nvim_lsp.html.setup{on_attach = on_attach_lsp}
  nvim_lsp.cssls.setup{on_attach = on_attach_lsp}
  nvim_lsp.tsserver.setup{on_attach = on_attach_lsp}
  nvim_lsp.pyright.setup{on_attach = on_attach_lsp}
  nvim_lsp.r_language_server.setup{on_attach = on_attach_lsp}
  nvim_lsp.gopls.setup{on_attach = on_attach_lsp}
  nvim_lsp.rust_analyzer.setup{on_attach = on_attach_lsp}
end

-- treesitter settings
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = { },
  },
}

