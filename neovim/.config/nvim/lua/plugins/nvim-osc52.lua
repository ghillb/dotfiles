local packer_opts = {
  "ojroques/nvim-osc52",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local ok, osc52 = pcall(require, "osc52")
    if not ok then
      return
    end

    local config = {
      max_length = 1000000, -- Maximum length of selection
      silent = false, -- Disable message on successful copy
      trim = false, -- Trim text before copy
    }

    osc52.setup(config)

    -- :h provider-clipboard
    -- local function copy(lines, _)
    --   osc52.copy(table.concat(lines, "\n"))
    -- end

    -- local function paste()
    --   return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
    -- end

    -- vim.g.clipboard = {
    --   name = "osc52",
    --   copy = { ["+"] = copy, ["*"] = copy, ['"'] = copy },
    --   paste = { ["+"] = paste, ["*"] = paste, ['"'] = paste },
    -- }

    -- Now the '+' register will copy to system clipboard using OSC52
    -- vim.keymap.set("n", "y", '""y')
    -- vim.keymap.set("n", "yy", '""yy')
    -- vim.keymap.set("n", "<leader>c", '""y')
    -- vim.keymap.set("n", "<leader>cc", '""yy')
    --
    vim.keymap.set("n", "<leader>y", require("osc52").copy_operator, { expr = true })
    vim.keymap.set("n", "<leader>yy", "<leader>y_", { remap = true })
    vim.keymap.set("x", "<leader>y", require("osc52").copy_visual)
  end,
}
return packer_opts
