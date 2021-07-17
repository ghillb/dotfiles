local ok, rust_tools = pcall(require, 'rust-tools')
if not ok then
  return
end

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

local opts = {
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    runnables = {
      use_telescope = false
    },
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = "<-",
      other_hints_prefix  = "=>",
    },
  },
  server = {settings = rust_analyzer_settings},
}

rust_tools.setup(opts)

