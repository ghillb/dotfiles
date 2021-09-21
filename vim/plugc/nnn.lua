local ok, nnn = pcall(require, 'nnn')
if not ok then
  return
end

local function copy_to_clipboard(lines)
  local joined_lines = table.concat(lines, "\n")
  vim.fn.setreg("+", joined_lines)
end

nnn.setup {
  command = "nnn -o -C",
  set_default_mappings = 0,
  replace_netrw = 1,
  action = {
    ["<c-t>"] = "tab split",
    ["<c-s>"] = "split",
    ["<c-v>"] = "vsplit",
    ["<c-o>"] = copy_to_clipboard,
  },
}

vim.g["nnn#set_default_mappings"] = 0
vim.g["nnn#session"] = 'local'

