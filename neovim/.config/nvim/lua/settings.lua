vim.env.NVIM_CONFIG                   = vim.fn.stdpath('config')

if vim.fn.has("unix") == 1 then
  vim.opt.spell                             = true
  vim.opt.shell                             = "dash"
end

vim.opt.encoding                            = 'utf-8'
vim.opt.fileencoding                        = 'utf-8'
vim.opt.clipboard                           = 'unnamedplus'
vim.opt.mouse                               = 'nvi'
vim.opt.backspace                           = 'indent,eol,start'
vim.opt.whichwrap                           = 'b,s,<,>,h,l,[,]'
vim.opt.spelllang                           = 'en_us,de_de'
vim.opt.termguicolors                       = true
vim.opt.autochdir                           = false
vim.opt.confirm                             = true
vim.opt.backup                              = false
vim.opt.swapfile                            = false
vim.opt.autoindent                          = true
vim.opt.smartindent                         = true
vim.opt.expandtab                           = true
vim.opt.tabstop                             = 2
vim.opt.shiftwidth                          = 2
vim.opt.softtabstop                         = 2
vim.opt.textwidth                           = 100
vim.opt.wrapmargin                          = 0
vim.opt.scrolloff                           = 5
vim.opt.colorcolumn                         = ''
vim.opt.signcolumn                          = 'yes:2'
vim.opt.formatoptions                       = 'jcroql'
vim.opt.wrap                                = true
vim.opt.linebreak                           = true
vim.opt.hlsearch                            = true
vim.opt.ignorecase                          = true
vim.opt.incsearch                           = true
vim.opt.smartcase                           = true
vim.opt.background                          = 'dark'
vim.opt.number                              = true
vim.opt.relativenumber                      = true
vim.opt.showmode                            = false
vim.opt.visualbell                          = true
vim.opt.splitbelow                          = true
vim.opt.splitright                          = true
-- vim.opt.splitscroll                         = false -- 0.9?
vim.opt.showtabline                         = 0
vim.opt.cmdheight                           = 0
vim.opt.updatetime                          = 100
vim.opt.hidden                              = true
vim.opt.title                               = true
vim.opt.undofile                            = true
vim.opt.undodir                             = vim.env.NVIM_CONFIG .. '/undodir'
vim.opt.wildmode                            = 'longest:full,full'
vim.opt.wildignore                          = '*.o,*~,*.pyc,*.pyo,__pycache__,*/venv/*'
vim.opt.completeopt                         = 'menu,menuone,noselect,noinsert'
vim.opt.complete                            = '.,w,b,u,t,kspell'
vim.opt.shortmess                           = 'filnxtToOFIcS'
vim.opt.fillchars                           = { eob = '·', fold = ' ', foldopen = '', foldsep = ' ', foldclose = '' }
vim.opt.grepprg                             = "rg --vimgrep $* /dev/null"
vim.opt.grepformat                          = "%f:%l:%c:%m"
-- fold settings
vim.opt.foldmethod                          = "expr"
vim.opt.foldexpr                            = "nvim_treesitter#foldexpr()"
vim.opt.foldtext                            = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
vim.opt.foldnestmax                         = 3
vim.opt.foldminlines                        = 1
vim.opt.foldcolumn                          = '1'

-- netrw settings
vim.g.netrw_banner                          = 0
vim.g.netrw_liststyle                       = 0
vim.g.netrw_browse_split                    = 0
vim.g.netrw_winsize                         = 25
vim.g.netrw_altv                            = 1
vim.g.netrw_fastbrowse                      = 0

-- load local settings
user.fn.load_local_config()

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


