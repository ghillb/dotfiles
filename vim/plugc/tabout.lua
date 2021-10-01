local ok, tabout = pcall(require, 'tabout')
if not ok then
  return
end
tabout.setup {
  tabkey = '<Tab>',
  backwards_tabkey = '<S-Tab>',
  act_as_tab = true,
  act_as_shift_tab = true,
  enable_backwards = true,
  completion = false,
  tabouts = {
    {open = "'", close = "'"},
    {open = '"', close = '"'},
    {open = '`', close = '`'},
    {open = '(', close = ')'},
    {open = '[', close = ']'},
    {open = '{', close = '}'}
  },
  ignore_beginning = true,
  exclude = {}
}
