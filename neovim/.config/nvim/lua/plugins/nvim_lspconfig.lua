return {
  "neovim/nvim-lspconfig",
  lazy = false,
  config = function()
    local group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })
    local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end

        local bufopts = { noremap = true, silent = true, buffer = args.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<space>f", function()
          vim.lsp.buf.format({ async = true })
        end, bufopts)

        if client:supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = format_group, buffer = args.buf })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = format_group,
            buffer = args.buf,
            desc = "Format with the attached LSP client before saving",
            callback = function()
              vim.lsp.buf.format({ async = false, bufnr = args.buf, id = client.id, timeout_ms = 2000 })
            end,
          })
        end
      end,
    })

    vim.lsp.enable("rust_analyzer")
  end,
}
