local status_ok, trouble = pcall(require, 'trouble')
if not status_ok then
  return
end

local config = {
  use_lsp_diagnostic_signs = false,
  icons=false
}

trouble.setup(config)
