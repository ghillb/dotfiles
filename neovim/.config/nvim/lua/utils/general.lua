local M = {}

function M.filereadable(path)
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function M.reload(mod)
  package.loaded[mod] = nil
  require(mod)
end

function M.toggle_variable(args)
  local ok, val = pcall(vim.api.nvim_get_var, args.var)
  if not ok then
    vim.api.nvim_set_var(args.var, args.default)
    return
  end
  vim.api.nvim_set_var(args.var, not val)
end

function M.load_local_config()
  local ok, localrc = pcall(require, "localrc")
  if ok then
    localrc.settings.load()
  end
end

function _G.switch(param, cases)
  local case = cases[param]
  if case then
    return case()
  end
  local def = cases["default"]
  return def and def() or nil
end

return M