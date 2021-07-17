local ok, trouble = pcall(require, 'trouble')
if not ok then
  return
end

local config = {
  use_lsp_diagnostic_signs = false,
  icons=false
}

trouble.setup(config)
