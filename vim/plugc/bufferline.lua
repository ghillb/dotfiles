local ok, bufferline = pcall(require, 'bufferline')
if not ok then
  return
end

local config = {
  options = {
    view = "multiwindow",
    numbers = "none",
    number_style = "none",
    mappings = false,
    indicator_icon = '',
    buffer_close_icon = '⨯',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    diagnostics = "none",
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = false,
    persist_buffer_sort = true, 
    separator_style = {"", ""},
    enforce_regular_tabs = true,
    always_show_bufferline = false,
    sort_by = 'extension',
    custom_filter = function(buf_number)
       if vim.bo[buf_number].filetype ~= "vimwiki" then
         return true
       end
       if vim.fn.bufname(buf_number) ~= ".git/index" then
         return true
       end
     end,
    offsets = {{filetype = "fern", text = "tree", text_align = "center"}},
  }
}

bufferline.setup(config)

