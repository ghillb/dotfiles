local packer_opts = {
  "abecodes/tabout.nvim",
  wants = { "nvim-treesitter" },
  config = function()
    local ok, tabout = pcall(require, "tabout")
    if not ok then
      return
    end

    local config = {
      tabkey = "",
      backwards_tabkey = "",
      act_as_tab = true,
      act_as_shift_tab = true,
      enable_backwards = true,
      completion = false,
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
      },
      ignore_beginning = true,
      exclude = {},
    }

    tabout.setup(config)

    -- nvim-cmp compatible bindings
    local function replace_keycodes(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    function _G.tab_binding()
      if vim.fn.pumvisible() ~= 0 then
        return replace_keycodes("<C-n>")
      elseif vim.fn["vsnip#available"](1) ~= 0 then
        return replace_keycodes("<Plug>(vsnip-expand-or-jump)")
      else
        return replace_keycodes("<Plug>(Tabout)")
      end
    end

    function _G.s_tab_binding()
      if vim.fn.pumvisible() ~= 0 then
        return replace_keycodes("<C-p>")
      elseif vim.fn["vsnip#jumpable"](-1) ~= 0 then
        return replace_keycodes("<Plug>(vsnip-jump-prev)")
      else
        return replace_keycodes("<Plug>(TaboutBack)")
      end
    end

    vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_binding()", { expr = true })
    vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_binding()", { expr = true })
  end,
}
return packer_opts
