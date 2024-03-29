local aucmd = vim.api.nvim_create_autocmd
local augrp = vim.api.nvim_create_augroup

aucmd("VimEnter", {
  callback = function()
    user.fn.set_root("start_dir", false)
  end,
  group = augrp("VimEnterGroup", { clear = true }),
})

aucmd("BufEnter", { callback = user.fn.populate_info, group = augrp("BufEnterGroup", { clear = true }) })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("SetProjectSettings", { clear = true }),
  callback = _G.set_project_settings or function() end,
})

aucmd("BufUnload", {
  pattern = "<buffer>",
  command = "call timer_start(1, { tid -> execute('lua user.fn.set_root(\"git_worktree\")')})",
  group = augrp("BufUnloadGroup", { clear = true }),
})

aucmd("DirChanged", {
  callback = function()
    local root_config_path = vim.fn.getcwd() .. "/.nvim.lua"
    if user.fn.filereadable(root_config_path) then
      vim.cmd("source " .. root_config_path)
    end
  end,
  group = augrp("DirChangedGroup", { clear = true }),
})

aucmd({ "TextChanged", "TextChangedI" }, {
  callback = function()
    if user.fn.filereadable(vim.api.nvim_buf_get_name(0)) and not vim.o.readonly then
      vim.cmd("silent write")
    end
  end,
  group = augrp("TextChangedGroup", { clear = true }),
})

aucmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
  end,
  group = augrp("TextYankPostGroup", { clear = true }),
})

aucmd("BufWritePre", {
  callback = function()
    -- vim.lsp.buf.formatting_seq_sync(nil, 2000)
    vim.lsp.buf.format({ async = true })
  end,
  group = augrp("BufWritePreGroup", { clear = true }),
})

aucmd(
  "BufWritePost",
  { pattern = "init.lua", command = "source $MYVIMRC", group = augrp("BufWritePostGroup", { clear = true }) }
)

-- binary edit auto cmds

local _binary_edit = augrp("Binary", { clear = true })

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

