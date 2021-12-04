local ok, null_ls = pcall(require, "null-ls")
if not ok then
	return
end

local opts = {

	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.terraform_fmt,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.prettier.with({
			filetypes = table.merge(null_ls.builtins.formatting.prettier.filetypes, { "docker-compose" }),
		}),
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

null_ls.config(opts)
require("lspconfig")["null-ls"].setup({})
