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

function M.load_local_config()
  local ok, localrc = pcall(require, "localrc")
  if ok then
    localrc.settings.load()
  end
end

return M
