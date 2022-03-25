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
    plug({ remote = "luisiacc/gruvbox-baby" })
    plug({ remote = "rebelot/kanagawa.nvim" })
    plug({ remote = "navarasu/onedark.nvim" })
    plug({ remote = "folke/tokyonight.nvim" })
    plug({ remote = "tpope/vim-fugitive" })
    plug({ remote = "will133/vim-dirdiff" })
    plug({ remote = "junegunn/gv.vim" })
    plug({ remote = "tpope/vim-surround" })
    plug({ config = "vimwiki" })
    plug({ config = "neorg" })
    plug({ remote = "mbbill/undotree" })
    plug({ config = "neoterm" })
    plug({ config = "codi" })
    plug({ config = "nvim-luapad" })
    plug({ remote = "chaoren/vim-wordmotion" })
    plug({ remote = "arthurxavierx/vim-caser" })
    plug({ config = "lightspeed" })
    plug({ config = "vsnip" })
    plug({ remote = "RRethy/vim-illuminate" })
    plug({ remote = "rafamadriz/friendly-snippets" })
    plug({ config = "mvvis" })
    plug({ config = "async_tasks" })
    plug({ remote = "neovim/nvim-lspconfig" })
    plug({ config = "nvim-lsp-installer" })
    plug({ config = "null_ls" })
    plug({ config = "treesitter" })
    plug({ config = "nvim-dap" })
    plug({ config = "vim-ultest" })
    plug({ config = "telescope" })
    plug({ config = "nvim-cmp" })
    plug({ remote = "onsails/lspkind-nvim" })
    plug({ config = "lsp_signature" })
    plug({ remote = "kosayoda/nvim-lightbulb" })
    plug({ config = "aerial" })
    plug({ config = "autopairs" })
    plug({ config = "gitsigns" })
    plug({ config = "diffview" })
    plug({ config = "toggleterm" })
    plug({ config = "indent-blankline" })
    plug({ config = "trouble" })
    plug({ config = "todo-comments" })
    plug({ config = "which-key" })
    plug({ config = "persistence" })
    plug({ config = "twilight" })
    plug({ config = "zen-mode" })
    plug({ config = "nvim-colorizer" })
    plug({ config = "lualine" })
    plug({ config = "cokeline" })
    plug({ config = "nvim-tree" })
    plug({ config = "rust-tools" })
    plug({ config = "nnn" })
    plug({ config = "tabout" })
    plug({ remote = "wellle/targets.vim" })
    plug({ remote = "p00f/nvim-ts-rainbow" })
    plug({ config = "qf_helper" })
    plug({ config = "alpha" })
    plug({ remote = "kenn7/vim-arsync" })
    plug({ config = "glow" })
    plug({ config = "neogen" })
    plug({ config = "nvim-neoclip" })
    plug({ config = "comment" })
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },
  },
})
