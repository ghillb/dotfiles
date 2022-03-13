local packer_opts = {
  "hrsh7th/nvim-cmp",
  requires = {
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-cmdline" },
  },
  config = function()
    if vim.env.NVIM_INIT then return end
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local neogen = require("neogen")

    -- neogen mapping helper
    local t = function(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
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
        ["<a-cr>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<c-q>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
        ["<cr>"] = cmp.mapping(
          cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          { "i", "c" }
        ),
        ["<tab>"] = cmp.mapping(function(fallback)
          if neogen.jumpable() then
            vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_next()<cr>"), "")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<s-tab>"] = cmp.mapping(function(fallback)
          if neogen.jumpable(-1) then
            vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_prev()<CR>"), "")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },
      sources = {
        { name = "vsnip", max_item_count = 5 },
        { name = "nvim_lsp" },
        { name = "nvim_lua", max_item_count = 5 },
        { name = "buffer", max_item_count = 5 },
        { name = "path", max_item_count = 5 },
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
          maxwidth = 70,
        }),
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      experimental = {
        ghost_text = true,
        native_menu = false,
      },
      preselect = cmp.PreselectMode.None,
    })

    require("cmp").setup.cmdline("/", {
      sources = {
        { name = "buffer" },
      },
    })

    require("cmp").setup.cmdline(":", {
      sources = {
        { name = "cmdline" },
        { name = "path", option = {
          trailing_slash = true,
        } },
      },
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
  end,
}
return packer_opts
