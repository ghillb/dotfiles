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
      
      vim.keymap.set("n", "<C-s>", function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if entry and entry.type == "file" then
          local file_path = oil.get_current_dir() .. entry.name
          local result = vim.system({"git", "add", "-f", file_path}):wait()
          
          if result.code == 0 then
            vim.notify("Staged: " .. entry.name, vim.log.levels.INFO)
            require("utils.oil_git").refresh()
          else
            vim.notify("Failed to stage: " .. (result.stderr or "Unknown error"), vim.log.levels.ERROR)
          end
        else
          vim.notify("Please select a file to stage", vim.log.levels.WARN)
        end
      end, { buffer = args.buf, desc = "Force stage file" })
    end,
  })
  
  require("utils.oil_git").setup()
end
