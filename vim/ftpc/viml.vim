lua <<EOF
    local has_lsp, nvim_lsp = pcall(require, 'nvim_lsp')
    if has_lsp then
        nvim_lsp.vimls.setup{on_attach=require'completion'.on_attach}
    end
EOF

