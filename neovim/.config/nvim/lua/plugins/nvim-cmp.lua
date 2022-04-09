local packer_opts = {
  "hrsh7th/nvim-cmp",
  requires = {
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-cmdline" },
    -- { "hrsh7th/cmp-copilot" },
  },
  config = function()
    local ok, cmp = pcall(require, "cmp")
    if not ok then
      return
    end

    local lspkind = require("lspkind")

    local config = {
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },

      mapping = {
        ["<up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<c-d>"] = cmp.mapping.scroll_docs(4),
        ["<c-u>"] = cmp.mapping.scroll_docs(-4),
        ["<a-cr>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<c-q>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
        ["<cr>"] = cmp.mapping(
          cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          { "i", "c" }
        ),
      },
      sources = {
        { name = "vsnip", max_item_count = 5 },
        { name = "nvim_lsp" },
        { name = "nvim_lua", max_item_count = 5 },
        { name = "buffer", max_item_count = 5 },
        { name = "path", max_item_count = 5 },
        -- { name = "copilot" },
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
            -- copilot = "[copi]",
          },
          with_text = false,
          maxwidth = 70,
        }),
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
      preselect = cmp.PreselectMode.None,
    }

    cmp.setup.cmdline("/", {
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      sources = {
        { name = "cmdline" },
        { name = "path", option = {
          trailing_slash = true,
        } },
      },
    })

    cmp.setup(config)

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
  end,
}
return packer_opts
