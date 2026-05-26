local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Indentation (match VS Code: 2 spaces)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Don't conceal characters in markdown / JSON
opt.conceallevel = 0

-- Keep cursor centred-ish when scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- System clipboard
opt.clipboard = "unnamedplus"

-- Better splits
opt.splitright = true
opt.splitbelow = true

-- Persistent undo
opt.undofile = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Show substitution preview live
opt.inccommand = "split"

-- Shorter update time (faster CursorHold, gitsigns, etc.)
opt.updatetime = 200
