require("filetype").setup({
	overrides = {
		extensions = {
			tf = "terraform",
		},
		literal = {},
		complex = {
			[".*.gitlab.*.yml"] = "gitlab-ci",
			[".*docker.compose.*"] = "docker-compose",
		},

		function_extensions = {},
		function_literal = {},
		function_complex = {},
	},
})

