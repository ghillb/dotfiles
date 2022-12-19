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

-- load local and project specific settings
user.fn.load_local_config()
user.fn.load_project_config()

-- lsp and diagnostics settings
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = nil,
})

vim.lsp.handlers["textDocument/signtureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = nil,
})

vim.diagnostic.config({
  signs = false,
  severity_sort = true,
  update_in_insert = false,
  underline = true,
  float = { show_header = false, border = nil, source = "always", focusable = false, header = "", prefix = "" },
  virtual_text = {
    format = function() -- diagnostic
      return ""
    end,
    prefix = "●"
  },
})

_G.DiagnosticSigns = { Error = " ", Warn = " ", Hint = " ", Info = " " } --

for type, icon in pairs(_G.DiagnosticSigns) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end


