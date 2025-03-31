----- BASIC OPTIONS ---

-- Using leader key prevents other plugins from interfering.
-- Leader key is now space
vim.g.mapleader = " "

vim.opt.linebreak = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4

vim.opt.scrolloff = 1
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"
vim.opt.joinspaces = false
vim.opt.matchpairs = vim.opt.matchpairs + "<:>"

vim.opt.colorcolumn = { 80 }
vim.opt.mouse = "a"

vim.opt.cursorline = true

-- enable richer colors, also required by some
-- plugins like nvim-colorizer.lua
vim.opt.termguicolors = true

-- round borders on floating windows
vim.opt.winborder = 'rounded'

vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    command = "setlocal textwidth=72 colorcolumn=72"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact", "json", "css", "scss" },
    command = "setlocal tabstop=2 shiftwidth=2"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "scss",
    command = "setlocal iskeyword+=@-@"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    command = "setlocal colorcolumn=100"
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    command = "silent! lua vim.highlight.on_yank()"
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
