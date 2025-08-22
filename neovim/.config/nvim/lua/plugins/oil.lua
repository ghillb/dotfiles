return function()
  local ok, oil = pcall(require, "oil")
  if not ok then
    return
  end
  
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  
  oil.setup({
    default_file_explorer = true,
    columns = { "icon" },
    delete_to_trash = true,
    prompt_save_on_select_new_entry = false,
    win_options = {
      number = false,
      relativenumber = false,
      signcolumn = "yes:1",
    },
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 2,
      max_width = 100,
      max_height = 20,
      border = "rounded",
    },
  })
  
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    callback = function(args)
      local function oil_save_and_close()
        if vim.bo.modified then
          vim.cmd("write")
        else
          vim.api.nvim_buf_delete(0, { force = true })
        end
      end
      
      vim.keymap.set({"n", "i", "v"}, "<a-q>", oil_save_and_close, { buffer = args.buf })
      
      vim.keymap.set("n", "<BS>", "-", { buffer = args.buf, remap = true })
      
      vim.keymap.set("n", "<Tab>", require("oil").select, { buffer = args.buf })
      
      vim.keymap.set("n", "<C-s>", require("utils.oil_git").toggle_stage_current_file, { buffer = args.buf, desc = "Toggle stage/unstage file" })
    end,
  })
  
  require("utils.oil_git").setup()
end
