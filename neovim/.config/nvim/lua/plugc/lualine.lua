local ok, lualine = pcall(require, "lualine")
if not ok then
	return
end

local gruvbox_custom = require("lualine.themes.gruvbox")
local config = {
	options = {
		icons_enabled = true,
		theme = 'auto', --gruvbox_custom
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "NvimTree" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "g:git_modified_count", "diff" },
		lualine_c = {
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = {
					error = DiagnosticSigns.Error,
					warn = DiagnosticSigns.Warn,
					hint = DiagnosticSigns.Hint,
					info = DiagnosticSigns.Info,
				},
			},
			"g:breadcrumbs",
		},
		lualine_x = { "encoding", "filetype" },
		lualine_y = { GetLinePercent },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
}

local colors = {
	black = "#282828",
	white = "#ebdbb2",
	red = "#fb4934",
	green = "#b8bb26",
	blue = "#83a598",
	yellow = "#fe8019",
	pink = "#b16286",
	gray = "#a89984",
	darkgray = "#3c3836",
	lightgray = "#504945",
	inactivegray = "#7c6f64",
}

gruvbox_custom.normal = {
	a = { bg = colors.gray, fg = colors.black, gui = "bold" },
	b = { bg = colors.lightgray, fg = colors.white },
	c = { bg = colors.darkgray, fg = colors.gray },
}
gruvbox_custom.insert = {
	a = { bg = colors.blue, fg = colors.black, gui = "bold" },
	b = { bg = colors.lightgray, fg = colors.white },
	c = { bg = colors.darkgray, fg = colors.white },
}
gruvbox_custom.visual = {
	a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
	b = { bg = colors.lightgray, fg = colors.white },
	c = { bg = colors.inactivegray, fg = colors.black },
}
gruvbox_custom.terminal = {
	a = { bg = colors.pink, fg = colors.black, gui = "bold" },
	b = { bg = colors.lightgray, fg = colors.white },
	c = { bg = colors.darkgray, fg = colors.gray },
}
gruvbox_custom.replace = {
	a = { bg = colors.red, fg = colors.black, gui = "bold" },
	b = { bg = colors.lightgray, fg = colors.white },
	c = { bg = colors.black, fg = colors.white },
}
gruvbox_custom.command = {
	a = { bg = colors.green, fg = colors.black, gui = "bold" },
	b = { bg = colors.lightgray, fg = colors.white },
	c = { bg = colors.inactivegray, fg = colors.black },
}
gruvbox_custom.inactive = {
	a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
	b = { bg = colors.darkgray, fg = colors.gray },
	c = { bg = colors.darkgray, fg = colors.gray },
}

lualine.setup(config)
