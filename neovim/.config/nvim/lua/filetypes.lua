require("filetype").setup({
	overrides = {
		extensions = {
			tf = "terraform",
		},
		literal = {},
		complex = {
			[".*.gitlab.*.yml"] = "gitlab-ci",
			[".*.pb.*.yml"] = "ansible",
			[".*.tk.*.yml"] = "ansible",
			["docker.compose.yml"] = "docker-compose",
		},

		function_extensions = {},
		function_literal = {},
		function_complex = {},
	},
})

