vim.g.did_load_filetypes = 1
require('filetype').setup({
  overrides = {
    extensions = {
    },
    literal = {
    },
    complex = {
      [".*gitlab.*yml"] = "gitlab-ci",
    },

    function_extensions = {
    },
    function_literal = {
    },
    function_complex = {
    },
  }
})

vim.cmd 'au FileType markdown lua ApplyFTSettingsMarkdown()'
vim.cmd 'au FileType NvimTree lua ApplyFTSettingsNvimTree()'
vim.cmd 'au FileType qf lua ApplyFTSettingsQuickFix()'
vim.cmd 'au FileType git normal zR'
vim.cmd 'au FileType neoterm map <buffer> <tab> <nop>'
vim.cmd 'au FileType yaml,gitlab-ci setlocal indentkeys-=<:>'

function DisableTelescopeMappings()
  vim.api.nvim_buf_set_keymap(0, '', '<c-p>', '<nop>', { noremap = false, silent = true })
  vim.api.nvim_buf_set_keymap(0, '', '<c-e>', '<nop>', { noremap = false, silent = true })
  vim.api.nvim_buf_set_keymap(0, '', '<c-b>', '<nop>', { noremap = false, silent = true })
  vim.api.nvim_buf_set_keymap(0, '', '<c-g>', '<nop>', { noremap = false, silent = true })
  vim.api.nvim_buf_set_keymap(0, '', '<c-\\>', '<nop>', { noremap = false, silent = true })
end

function ApplyFTSettingsMarkdown()
  vim.opt.spell = true
  vim.bo.formatoptions = 'jroql'
  vim.b.surround_99 = "```\n\r\n```"  --c
  vim.b.surround_105 = "*\r*"         --i
  vim.b.surround_98 = "**\r**"        --b
end

function ApplyFTSettingsQuickFix()
  vim.api.nvim_buf_set_keymap(0, '', 'dd', ':call RemoveQFItem()<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, '', '<localleader>r', ':cdo s///', { noremap = true, silent = false })
  DisableTelescopeMappings()
end

function ApplyFTSettingsNvimTree()
  vim.api.nvim_buf_set_keymap(0, '', '<a-esc>', '<c-w>l', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, '', '<a-q>', ':NvimTreeClose<cr>', { noremap = true, silent = true })
  DisableTelescopeMappings()
end

