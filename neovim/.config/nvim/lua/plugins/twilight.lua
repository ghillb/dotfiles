
return function()
    local ok, twilight = pcall(require, 'twilight')
    if not ok then
      return
    end

    local config = {
      dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
      },
      context = 10,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {},
    }

    twilight.setup(config)
end
