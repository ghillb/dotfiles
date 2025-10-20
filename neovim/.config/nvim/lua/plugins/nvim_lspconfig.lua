return {
  "neovim/nvim-lspconfig",
  lazy = false,
  config = function()
    local lspconfig = require("lspconfig")

    local on_attach = function(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Note: Individual LSP servers should be configured here
    -- Example: lspconfig.gopls.setup({ on_attach = on_attach, capabilities = capabilities })
  end,
}
