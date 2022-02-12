local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

local opts = {

  sources = {
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.diagnostics.ansiblelint,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.completion.spell.with({ filetypes = { "markdown", "text" } }),
  },

  diagnostics_format = "#{m}",
  debounce = 250,
  default_timeout = 5000,
  update_on_insert = false,
  debug = false,
  log = {
    enable = true,
    level = "warn",
    use_console = "async",
  },
}

null_ls.setup(opts)
