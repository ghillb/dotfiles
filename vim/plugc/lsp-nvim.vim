let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

lua <<EOF
    local has_lsp, nvim_lsp = pcall(require, 'nvim_lsp')
    if has_lsp then
        local on_attach_lsp = function(client)
            require'completion'.on_attach(client)
            require'diagnostic'.on_attach(client)
        end
        nvim_lsp.bashls.setup{on_attach=on_attach_lsp}
        nvim_lsp.vimls.setup{on_attach=on_attach_lsp}
    end
EOF

