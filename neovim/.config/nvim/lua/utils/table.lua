function table.merge(...)
  local result = {}
  for _, t in ipairs({ ... }) do
    for k, v in pairs(t) do
      result[k] = v
    end
  end
  return result
end

function table.deep_copy(t, seen)
  local result = {}
  seen = seen or {}
  seen[t] = result
  for key, value in pairs(t) do
    if type(value) == "table" then
      result[key] = seen[value] or table.deep_copy(value, seen)
    else
      result[key] = value
    end
  end
  return result
end

function table.split_string_into_table(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

return {}