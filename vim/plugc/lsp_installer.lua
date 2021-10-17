local ok, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not ok then
  return
end

lsp_installer.settings {
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
}

lsp_installer.on_server_ready(function(server)
    local opts = {}

    if server.name == "ansiblels" then
      opts.filetypes = { "yaml", "yml" }
      opts.settings = {
        ansible = {
          ansible = {
            path = "ansible"
          },
          ansibleLint = {
            enabled = true,
            path = "ansible-lint"
          },
          executionEnvironment = {
            enabled = false,
          },
          python = {
            interpreterPath = "python3"
          }
        }
      }
    end

    if server.name == "yamlls" then
      opts.settings = {
        yaml = {
          schemas = {
            ['https://json.schemastore.org/ansible-playbook.json'] = '*.pb.{yml,yaml}',
            ['http://json.schemastore.org/gitlab-ci.json'] = '*.gitlab-ci.{yml,yaml}',
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
    end

    -- nvim-cmp
    opts.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

