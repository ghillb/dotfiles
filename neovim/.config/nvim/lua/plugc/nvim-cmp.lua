local ok_cmp, cmp = pcall(require, "cmp")
local ok_lspkind, lspkind = pcall(require, "lspkind")
if not ok_cmp and ok_lspkind then
  return
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<c-d>"] = cmp.mapping.scroll_docs(4),
    ["<c-u>"] = cmp.mapping.scroll_docs(-4),
    ["<a-cr>"] = cmp.mapping.complete(),
    ["<c-q>"] = cmp.mapping.close(),
    ["<c-cr>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "vsnip" },
    { name = "buffer" },
    { name = "path" },
    { name = "neorg" },
  },
  documentation = {
    border = "single",
  },
  formatting = {
    format = lspkind.cmp_format({
      menu = {
        vsnip = "[snip]",
        nvim_lsp = "[lsp]",
        nvim_lua = "[nvim]",
        buffer = "[buff]",
        path = "[path]",
      },
      with_text = false,
      maxwidth = 50,
    }),
  },
  completion = {
    completeopt = "menu,menuone,noinsert,noselect",
  },
  experimental = {
    ghost_text = true,
    native_menu = false,
  },
  preselect = cmp.PreselectMode.Item,
})

require("cmp").setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

-- require("cmp").setup.cmdline(":", {
  -- sources = {
    -- { name = "cmdline" },
    -- { name = "path" },
  -- },
-- })

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
