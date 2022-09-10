local packer_opts = {
  "lervag/vimtex",
  config = function()
    vim.g.vimtex_view_method = "zathura"

    -- vim.g.vimtex_view_general_viewer = "okular"
    -- vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

    vim.g.vimtex_compiler_method = "latexmk"
    -- vim.g.vimtex_compiler_method = "latexrun"
  end,
}
return packer_opts
