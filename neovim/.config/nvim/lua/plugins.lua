local fn = vim.fn

-- bootstrap packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd("packadd packer.nvim")
end

-- auto compile
vim.api.nvim_create_autocmd("BufWritePost", { pattern = "plugins.lua", command = "source <afile> | PackerCompile" })

return require("packer").startup({
  function(use)
    local ok, localrc = pcall(require, "localrc")
    if ok then
      for _, plugin in pairs(localrc.plugins) do
        use(plugin)
      end
    end

    local function plug(args)
      if args.remote ~= nil then
        use(args.remote)
      else
        use(require("plugins." .. args.config))
      end
    end

    plug({ remote = "wbthomason/packer.nvim" })
    if vim.fn.has("unix") == 1 then
      plug({ remote = "luisiacc/gruvbox-baby" })
      plug({ remote = "EdenEast/nightfox.nvim" })
      plug({ remote = "folke/tokyonight.nvim" })
      plug({ remote = "tpope/vim-fugitive" })
      plug({ remote = "will133/vim-dirdiff" })
      plug({ remote = "junegunn/gv.vim" })
      plug({ remote = "tpope/vim-surround" })
      plug({ config = "vimwiki" })
      plug({ config = "vimtex" })
      plug({ config = "neorg" })
      plug({ remote = "mbbill/undotree" })
      plug({ config = "neoterm" })
      plug({ config = "copilot" })
      plug({ config = "codi" })
      plug({ config = "sniprun" })
      plug({ config = "nvim-luapad" })
      plug({ config = "vim-caser" })
      plug({ config = "leap" })
      plug({ config = "vsnip" })
      plug({ config = "vim-illuminate" })
      plug({ remote = "rafamadriz/friendly-snippets" })
      plug({ config = "mvvis" })
      plug({ config = "overseer" })
      plug({ remote = "neovim/nvim-lspconfig" })
      plug({ config = "mason" })
      plug({ config = "null_ls" })
      plug({ config = "treesitter" })
      plug({ config = "nvim-dap" })
      plug({ config = "neotest" })
      plug({ config = "telescope" })
      plug({ config = "nvim-cmp" })
      plug({ remote = "onsails/lspkind-nvim" })
      plug({ config = "nvim-lightbulb" })
      plug({ config = "aerial" })
      plug({ config = "autopairs" })
      plug({ config = "gitsigns" })
      plug({ config = "diffview" })
      plug({ config = "git-conflict" })
      plug({ config = "toggleterm" })
      plug({ config = "indent-blankline" })
      plug({ config = "trouble" })
      plug({ config = "todo-comments" })
      plug({ config = "which-key" })
      plug({ config = "persistence" })
      plug({ config = "nvim-spectre" })
      plug({ config = "noice" })
      plug({ config = "twilight" })
      plug({ config = "zen-mode" })
      plug({ config = "nvim-highlight-colors" })
      plug({ config = "lualine" })
      plug({ config = "neo-tree" })
      plug({ config = "cybu" })
      plug({ config = "rust-tools" })
      plug({ remote = "chrisbra/csv.vim" })
      plug({ remote = "tpope/vim-dadbod" })
      plug({ remote = "kristijanhusak/vim-dadbod-ui" })
      plug({ config = "nnn" })
      plug({ remote = "wellle/targets.vim" })
      plug({ config = "qf_helper" })
      plug({ config = "alpha" })
      plug({ config = "vim-arsync" })
      plug({ config = "glow" })
      plug({ config = "neogen" })
      plug({ config = "nvim-neoclip" })
      plug({ config = "nvim-osc52" })
      plug({ config = "comment" })
    end
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "none" })
      end,
      prompt_border = "none",
    },
  },
})
