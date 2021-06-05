require('bufferline').setup {
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
    offsets = {{filetype = "fern", text = "tree", text_align = "center"}},
  }
}

