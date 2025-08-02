
return function()
  local ok, which_key = pcall(require, "which-key")
  if not ok then
    return
  end

  local config = {
    window = {
      border = "none",
    },
  }

  which_key.setup(config)
end