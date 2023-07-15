"==BASIC== settings
set nocompatible
set backspace=indent,eol,start

set linebreak
set relativenumber

"use spaces for tab instead of actual \t
set expandtab
set tabstop=4

set autoindent
set smartindent
"for auto indent
set shiftwidth=4

set showcmd

"only make temp backup, not permanent backup
set nobackup
set writebackup

set scrolloff=1

set ruler
set laststatus=2

"allow these keys to move with word wrapping
"the following four symbols are cursor keys: <, >, [, ]
set whichwrap=b,s,h,l,<,>,[,]

set nojoinspaces
set viminfo=""
set hlsearch

"angular brackets should also match as pairs
set matchpairs+=<:>

set clipboard=autoselect,exclude:.*

syntax on

"==ADVANCED== settings (plugins, powerline, etc.)
