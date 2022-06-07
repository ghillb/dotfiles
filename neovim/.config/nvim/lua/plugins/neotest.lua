local packer_opts = {
  "rcarriga/neotest",
  requires = {
    "rcarriga/neotest-vim-test",
    "rcarriga/neotest-python",
    "rcarriga/neotest-plenary",
    "vim-test/vim-test",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
  },
  config = function()
    local ok, neotest = pcall(require, "neotest")
    if not ok then
      return
    end

    neotest.setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
        }),
        require("neotest-plenary"),
        require("neotest-vim-test")({
          ignore_file_types = { "python", "vim", "lua" },
        }),
      },
    })

    vim.keymap.set("n", "<c-t><c-f>", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end)
    vim.keymap.set("n", "<c-t><c-t>", function()
      require("neotest").run.run()
    end) -- run nearest test
    vim.keymap.set("n", "<c-t><c-d>", function()
      require("neotest").run.run({ strategy = "dap" })
    end) -- debug nearest test
    vim.keymap.set("n", "<c-t><c-n>", function()
      require("neotest").run.stop()
    end)
    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").summary.toggle()
    end)
    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output.open({ enter = true })
    end)
  end,
}
return packer_opts
