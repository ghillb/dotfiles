-- general settings
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = true,
    virtual_text = false,
  }
)

local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end 

local nvim_command = vim.api.nvim_command

-- lsp set-ups
local on_attach = function(client, bufnr)
  nvim_command('autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })')
end

local has_lsp, nvim_lsp = pcall(require, 'lspconfig')
if has_lsp then
  nvim_lsp.bashls.setup{on_attach = on_attach}
  nvim_lsp.vimls.setup{on_attach = on_attach}
  nvim_lsp.jsonls.setup{on_attach = on_attach}
  nvim_lsp.yamlls.setup{on_attach = on_attach, settings = yamlls_settings}
  nvim_lsp.dockerls.setup{on_attach = on_attach}
  nvim_lsp.terraformls.setup{on_attach = on_attach, filetypes = {"tf"}}
  nvim_lsp.html.setup{on_attach = on_attach}
  nvim_lsp.cssls.setup{on_attach = on_attach}
  nvim_lsp.tsserver.setup{on_attach = on_attach}
  nvim_lsp.pyright.setup{on_attach = on_attach}
  nvim_lsp.r_language_server.setup{on_attach = on_attach}
  nvim_lsp.gopls.setup{on_attach = on_attach}
end

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
