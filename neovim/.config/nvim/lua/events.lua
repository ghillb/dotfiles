local aucmd = vim.api.nvim_create_autocmd
local augrp = vim.api.nvim_create_augroup

vim.g.opened_with_dir = false

aucmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      local abs_path = vim.fn.fnamemodify(arg, ":p")
      -- Set nvim_root to prevent set_root from changing it
      vim.g.nvim_root = abs_path
      vim.g.opened_with_dir = true
      -- Defer the cd to happen after all other initialization
      vim.defer_fn(function()
        vim.cmd("cd " .. vim.fn.fnameescape(abs_path))
      end, 100)
    elseif arg == "" or vim.fn.isdirectory(arg) == 0 then
      user.fn.set_root("start_dir", false)
    end
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
  callback = function()
    if not vim.g.opened_with_dir then
      vim.fn.timer_start(1, function()
        user.fn.set_root("git_worktree")
      end)
    end
  end,
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

aucmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
  group = augrp("CheckFileChanges", { clear = true }),
})

aucmd("FileChangedShell", {
  callback = function()
    local filename = vim.fn.expand("<afile>")
    local choice = vim.fn.confirm(
      string.format('File "%s" has changed on disk.\nReload and lose unsaved changes?', filename),
      "&Yes\n&No",
      2,
      "Warning"
    )
    if choice == 1 then
      vim.v.fcs_choice = "reload"
    else
      vim.v.fcs_choice = ""
    end
  end,
  group = augrp("FileChangedPrompt", { clear = true }),
})

