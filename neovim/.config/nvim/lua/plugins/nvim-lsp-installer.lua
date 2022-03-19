local packer_opts = {
  "williamboman/nvim-lsp-installer",
  config = function()
    if vim.env.NVIM_INIT then
      return
    end
    local lsp_installer = require("nvim-lsp-installer")

    lsp_installer.settings({
      ui = {
        icons = {
          server_installed = "✓",
          server_pending = "➜",
          server_uninstalled = "✗",
        },
      },
    })

    lsp_installer.on_server_ready(function(server)
      local opts = {}

      if server.name == "sumneko_lua" then
        opts.settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "packer_plugins" },
            },
          },
        }
        opts.on_attach = function(client)
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false
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

      if server.name == "rust_analyzer" then
        local _, rust_tools = pcall(require, "rust-tools")

        local rust_tools_opts = {
          tools = {
            autoSetHints = true,
            hover_with_actions = true,
            runnables = {
              use_telescope = true,
            },
            debuggables = {
              use_telescope = true,
            },
            inlay_hints = {
              show_parameter_hints = true,
              parameter_hints_prefix = "<-",
              other_hints_prefix = "=>",
            },
          },
          server = server:get_default_options(),
        }
        rust_tools.setup(rust_tools_opts)
      end

      opts.capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
      opts.capabilities.textDocument.completion.completionItem.snippetSupport = true

      server:setup(opts)
    end)
  end,
}
return packer_opts
