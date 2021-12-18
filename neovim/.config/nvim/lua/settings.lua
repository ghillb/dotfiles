local opt = vim.opt

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

vim.env.NVIM_CONFIG                    = vim.fn.stdpath('config')
vim.env.MACCHINA_DISABLED              = 1

opt.shell                              = 'dash'
opt.encoding                           = 'utf-8'
opt.fileencoding                       = 'utf-8'
opt.clipboard                          = 'unnamedplus'
opt.mouse                              = 'nvi'
opt.backspace                          = 'indent,eol,start'
opt.whichwrap                          = 'b,s,<,>,h,l,[,]'
opt.spelllang                          = 'en_us,de_de'
opt.spell                              = false
opt.termguicolors                      = true
opt.autochdir                          = false
opt.confirm                            = true
opt.backup                             = false
opt.swapfile                           = false
opt.autoindent                         = true
opt.smartindent                        = true
opt.expandtab                          = true
opt.tabstop                            = 2
opt.shiftwidth                         = 2
opt.softtabstop                        = 2
opt.textwidth                          = 100
opt.wrapmargin                         = 0
opt.scrolloff                          = 5
opt.laststatus                         = 2
opt.colorcolumn                        = ''
opt.signcolumn                         = 'yes:2'
opt.formatoptions                      = 'jcroql'
opt.wrap                               = true
opt.linebreak                          = true
opt.foldmethod                         = 'syntax'
opt.foldnestmax                        = 1
opt.hlsearch                           = true
opt.ignorecase                         = true
opt.incsearch                          = true
opt.smartcase                          = true
opt.background                         = 'dark'
opt.number                             = true
opt.relativenumber                     = true
opt.showmode                           = false
opt.visualbell                         = true
opt.splitbelow                         = true
opt.splitright                         = true
opt.showtabline                        = 0
opt.updatetime                         = 100
opt.hidden                             = true
opt.title                              = true
opt.undofile                           = true
opt.undodir                            = vim.env.NVIM_CONFIG .. '/undodir'
opt.wildmode                           = 'longest:full,full'
opt.wildignore                         = '*.o,*~,*.pyc,*.pyo,__pycache__,*/venv/*'
opt.completeopt                        ='menu,menuone,noselect,noinsert'
opt.complete                           = '.,w,b,u,t,kspell'
opt.shortmess                          = 'filnxtToOFIc'
opt.fcs                                = 'eob:·'

-- netrw settings
vim.g.netrw_banner                     = 0
vim.g.netrw_liststyle                  = 0
vim.g.netrw_browse_split               = 0
vim.g.netrw_winsize                    = 25
vim.g.netrw_altv                       = 1
vim.g.netrw_fastbrowse                 = 0

-- lsp and diagnostics settings
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  severity_sort = true,
  update_in_insert = false,
  underline = true,
  float = { show_header = false, border = "single", source = "always", focusable = false, header = "", prefix = "" },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

vim.lsp.handlers["textDocument/signtureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})

DiagnosticSigns = { Error = " ", Warn = " ", Hint = " ", Info = " " } --

for type, icon in pairs(DiagnosticSigns) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.fn.sign_define("LightBulbSign", { text = "", texthl = "", linehl = "", numhl = "" })
vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
