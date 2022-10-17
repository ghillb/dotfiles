local o = vim.opt

vim.env.NVIM_CONFIG                   = vim.fn.stdpath('config')

if vim.fn.has("unix") == 1 then
  o.spell                             = true
  o.shell                             = "dash"
end

o.encoding                            = 'utf-8'
o.fileencoding                        = 'utf-8'
o.clipboard                           = 'unnamedplus'
o.mouse                               = 'nvi'
o.backspace                           = 'indent,eol,start'
o.whichwrap                           = 'b,s,<,>,h,l,[,]'
o.spelllang                           = 'en_us,de_de'
o.termguicolors                       = true
o.autochdir                           = false
o.confirm                             = true
o.backup                              = false
o.swapfile                            = false
o.autoindent                          = true
o.smartindent                         = true
o.expandtab                           = true
o.tabstop                             = 2
o.shiftwidth                          = 2
o.softtabstop                         = 2
o.textwidth                           = 100
o.wrapmargin                          = 0
o.scrolloff                           = 5
o.colorcolumn                         = ''
o.signcolumn                          = 'yes:2'
o.formatoptions                       = 'jcroql'
o.wrap                                = true
o.linebreak                           = true
o.hlsearch                            = true
o.ignorecase                          = true
o.incsearch                           = true
o.smartcase                           = true
o.background                          = 'dark'
o.number                              = true
o.relativenumber                      = true
o.showmode                            = false
o.visualbell                          = true
o.splitbelow                          = true
o.splitright                          = true
-- o.splitscroll                         = false
o.showtabline                         = 0
o.cmdheight                           = 0
o.updatetime                          = 100
o.hidden                              = true
o.title                               = true
o.undofile                            = true
o.undodir                             = vim.env.NVIM_CONFIG .. '/undodir'
o.wildmode                            = 'longest:full,full'
o.wildignore                          = '*.o,*~,*.pyc,*.pyo,__pycache__,*/venv/*'
o.completeopt                         = 'menu,menuone,noselect,noinsert'
o.complete                            = '.,w,b,u,t,kspell'
o.shortmess                           = 'filnxtToOFIcS'
o.fillchars                           = { eob = '·', fold = ' ', foldopen = '', foldsep = ' ', foldclose = '' }
o.grepprg                             = "rg --vimgrep $* /dev/null"
o.grepformat                          = "%f:%l:%c:%m"
-- fold settings
o.foldmethod                          = "expr"
o.foldexpr                            = "nvim_treesitter#foldexpr()"
o.foldtext                            = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
o.foldnestmax                         = 3
o.foldminlines                        = 1
o.foldcolumn                          = '1'

-- netrw settings
vim.g.netrw_banner                    = 0
vim.g.netrw_liststyle                 = 0
vim.g.netrw_browse_split              = 0
vim.g.netrw_winsize                   = 25
vim.g.netrw_altv                      = 1
vim.g.netrw_fastbrowse                = 0

-- lsp and diagnostics settings
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = nil,
})

vim.lsp.handlers["textDocument/signtureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = nil,
})

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  severity_sort = true,
  update_in_insert = false,
  underline = true,
  float = { show_header = false, border = nil, source = "always", focusable = false, header = "", prefix = "" },
})

_G.DiagnosticSigns = { Error = " ", Warn = " ", Hint = " ", Info = " " } --

for type, icon in pairs(_G.DiagnosticSigns) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

---Filters diagnostigs leaving only the most severe per line.
---@param diagnostics table[]
---@return table[]
---@see https://www.reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a/gvd8rb9/
---@see https://github.com/neovim/neovim/issues/15770
---@see https://github.com/lucasvianav/nvim/blob/8f763b85e2da9ebd4656bf732cbdd7410cc0e4e4/lua/v/settings/handlers.lua#L18-L48
---@see `:h diagnostic-handlers`
local filter_diagnostics = function(diagnostics)
    if not diagnostics then
        return {}
    end

    -- find the "worst" diagnostic per line
    local most_severe = {}
    for _, cur in pairs(diagnostics) do
        local max = most_severe[cur.lnum]

        -- higher severity has lower value (`:h diagnostic-severity`)
        if not max or cur.severity < max.severity then
            most_severe[cur.lnum] = cur
        end
    end

    -- return list of diagnostics
    return vim.tbl_values(most_severe)
end

---custom namespace
local ns = vim.api.nvim_create_namespace('severe-diagnostics')

---reference to the original handler
local orig_signs_handler = vim.diagnostic.handlers.signs

---Overriden diagnostics signs helper to only show the single most relevant sign
---@see `:h diagnostic-handlers`
vim.diagnostic.handlers.signs = {
    show = function(_, bufnr, _, opts)
        -- get all diagnostics from the whole buffer rather
        -- than just the diagnostics passed to the handler
        local diagnostics = vim.diagnostic.get(bufnr)

        local filtered_diagnostics = filter_diagnostics(diagnostics)

        -- pass the filtered diagnostics (with the
        -- custom namespace) to the original handler
        orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
    end,

    hide = function(_, bufnr)
        orig_signs_handler.hide(ns, bufnr)
    end,
}

