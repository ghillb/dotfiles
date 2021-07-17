local ok, formatter = pcall(require, 'formatter')
if not ok then
  return
end

local config = {
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
    },
    hcl = {
      -- terraform fmt
      function()
        return {
          exe = "terraform",
          args = {"fmt"},
          stdin = false
        }
      end
    }
  }
}

formatter.setup(config)

