local ok, trouble = pcall(require, 'trouble')
if not ok then
  return
end

local config = {
  use_diagnostic_signs = true,
  icons=false
}

trouble.setup(config)
