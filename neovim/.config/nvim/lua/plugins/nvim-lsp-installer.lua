local packer_opts = {
  "williamboman/nvim-lsp-installer",
  requires = { "folke/lua-dev.nvim" },
  config = function()
    local ok, nvim_lsp_installer = pcall(require, "nvim-lsp-installer")
    if not ok then
      return
    end

    local config = {
      ui = {
        icons = {
          server_installed = "✓",
          server_pending = "➜",
          server_uninstalled = "✗",
        },
      },
      ensure_installed = false,
    }

    nvim_lsp_installer.setup(config)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lsp-installer",
      callback = function()
        vim.api.nvim_win_set_config(0, { border = "none" })
      end,
    })

    -- lsp-config
    local lspconfig = require("lspconfig")
    for _, server in ipairs(nvim_lsp_installer.get_installed_servers()) do
      local opts = {}
      opts.capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
      -- opts.capabilities.textDocument.completion.completionItem.snippetSupport = true -- not needed?

      if server.name == "sumneko_lua" then
        opts = require("lua-dev").setup({})
        opts.on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end

      if server.name == "ansiblels" then
        opts.filetypes = { "ansible.yaml" }
        opts.settings = {
          ansible = {
            ansible = {
              path = "ansible",
            },
            ansibleLint = {
              enabled = true,
              path = "ansible-lint",
            },
            executionEnvironment = {
              enabled = false,
            },
            python = {
              interpreterPath = "python3",
            },
          },
        }
      end

      if server.name == "yamlls" then
        opts.filetypes = { "yaml", "yml", "gitlab-ci.yaml", "ansible.yaml", "docker-compose.yaml", "kubernetes.yaml" }
        opts.settings = {
          yaml = {
            schemas = {
              ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/*gitlab[-]ci*.yml",
              ["https://raw.githubusercontent.com/docker/cli/master/cli/compose/schema/data/config_schema_v3.9.json"] = "/*docker[-]compose*.yml",
              ["kubernetes"] = { "/k8s/*.yml", "/k8s/*.yaml" },
            },
            validate = true,
            hover = true,
            completion = true,
            format = {
              enable = true,
            },
          },
        }
      end

      lspconfig[server.name].setup({
        settings = opts.settings,
        filetypes = opts.filetypes,
        on_attach = opts.on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        capabilities = opts.capabilities,
      })
    end
  end,
}
return packer_opts
