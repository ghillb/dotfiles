return function()
  local ok, oil = pcall(require, "oil")
  if not ok then
    return
  end
  
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  local _oil_source_window = nil
  
  oil.setup({
    default_file_explorer = true,
    columns = { "icon", "permissions", "size", "mtime" },
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
    keymaps = {
      ["<CR>"] = function()
        local entry = oil.get_cursor_entry()
        
        if not entry then
          return
        end
        
        if entry.type == "directory" then
          oil.select()
        else
          local dir = oil.get_current_dir()
          local filepath = dir .. entry.name
          
          if _oil_source_window and vim.api.nvim_win_is_valid(_oil_source_window) then
            vim.api.nvim_set_current_win(_oil_source_window)
            vim.cmd("edit " .. vim.fn.fnameescape(filepath))
          else
            oil.select()
          end
        end
      end,
      ["<C-s>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-t>"] = "actions.select_tab",
    },
  })
  
  local function oil_toggle(detailed, as_drawer)
    if vim.bo.filetype == "oil" then
      if vim.bo.modified then
        vim.cmd("write")
      else
        vim.api.nvim_buf_delete(0, { force = true })
      end
    else
      local oil_win = nil
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_option(buf, "filetype") == "oil" then
          oil_win = win
          break
        end
      end
      
      if oil_win then
        vim.api.nvim_set_current_win(oil_win)
      else
        _oil_source_window = vim.api.nvim_get_current_win()
        
        if as_drawer then
          vim.cmd("rightbelow vsplit")
          local width = math.floor(vim.o.columns / 3)
          vim.cmd("vertical resize " .. width)
        end
        
        require("oil").open()
        if detailed then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end
    end
  end

  _G.oil_toggle = oil_toggle

  vim.keymap.set("n", "<a-e>", function() oil_toggle(false, false) end, { desc = "Toggle oil fullbuffer (simple)" })
  vim.keymap.set("n", "<a-E>", function() oil_toggle(true, false) end, { desc = "Toggle oil fullbuffer (detailed)" })
  
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
      
      vim.keymap.set("n", "<Left>", "-", { buffer = args.buf, remap = true })
      vim.keymap.set("n", "<Right>", "<CR>", { buffer = args.buf, remap = true })
      vim.keymap.set("n", "<Up>", "k", { buffer = args.buf, remap = true })
      vim.keymap.set("n", "<Down>", "j", { buffer = args.buf, remap = true })
      
      vim.keymap.set("n", "s", require("utils.oil_git").toggle_stage_current_file, { buffer = args.buf, desc = "Toggle stage/unstage file" })
      
      vim.keymap.set("v", "<C-v>", "<C-v>", { buffer = args.buf, desc = "Visual block selection" })
    end,
  })
  
  require("utils.oil_git").setup()
end
