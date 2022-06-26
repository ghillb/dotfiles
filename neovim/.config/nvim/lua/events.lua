local aucmd = vim.api.nvim_create_autocmd
local augrp = vim.api.nvim_create_augroup

local _vim_enter = augrp("VimEnterGroup", { clear = true })
local _binary_edit = augrp("Binary", { clear = true })

aucmd("VimEnter", {
  callback = function()
    _G.SetRoot("start_dir", false)
  end,
  group = _vim_enter,
})

aucmd("BufEnter", { callback = PopulateInfo })

aucmd(
  "BufUnload",
  { pattern = "<buffer>", command = "call timer_start(1, { tid -> execute('lua SetRoot(\"git_worktree\")')})" }
)

aucmd({ "TermEnter", "TermOpen" }, { command = "set ft=terminal" })

aucmd("DirChanged", {
  callback = function()
    local root_config_path = vim.fn.getcwd() .. "/.nvim.lua"
    if _G.filereadable(root_config_path) then
      vim.cmd("source " .. root_config_path)
    end
  end,
})

aucmd({ "TextChanged", "TextChangedI" }, {
  callback = function()
    if _G.filereadable(vim.api.nvim_buf_get_name(0)) and not vim.o.readonly then
      vim.cmd("silent write")
    end
  end,
})

aucmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
  end,
})

aucmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.formatting_seq_sync(nil, 2000)
  end,
})

aucmd("BufWritePost", { pattern = "init.lua", command = "source $MYVIMRC" })

-- binary edit auto cmds

aucmd("BufReadPost", {
  callback = function()
    vim.cmd("%!xxd")
    vim.bo.filetype = "xxd"
  end,
  pattern = "*.bin",
  group = _binary_edit,
})

aucmd("BufWritePre", {
  callback = function()
    vim.cmd("%!xxd -r")
  end,
  pattern = "*.bin",
  group = _binary_edit,
})

aucmd("BufWritePost", {
  callback = function()
    vim.cmd("%!xxd")
    vim.opt.mod = false
  end,
  pattern = "*.bin",
  group = _binary_edit,
})
