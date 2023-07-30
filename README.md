# dotfiles

## Neovim

### Prerequisites

* Nerd Fonts (used by: Telescope, lualine, ...)
    * https://www.nerdfonts.com/
* Ripgrep (used by: Spectre [find & replace], Telescope)
    * Windows: `scoop install ripgrep`
* Sed (used by: Spectre [find & replace], Telescope)
    * Windows: `scoop install sed`
* Clang (used by: Treesitter)
    * Windows: Use VS installer, set PATH to add tool (see [Treesitter Wiki](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support) for details)
* Node (used by: Lsp)
    * https://volta.sh/

### Config

* Windows: Manual copy
    * Destination: `~/AppData/Local/nvim/`
    * Comment: Unfortuntately the symbolic links feature in Windows does not suit our use case.
* Unix: `ln -s {source-file} {symbolic-file}`
    * Destination: `~/.config/nvim/`
    * Link `init.lua`, `lazy-lock.json`, `lua/wangleng/`

### Install

* Windows: `scoop install neovim`

## Gitui

### Config

* Windows: Manual copy
    * Destination: `~/AppData/Roaming/gitui/`
    * Comment: Unfortuntately the symbolic links feature in Windows does not suit our use case.
* Unix: `ln -s {source-file} {symbolic-file}`
    * Destination: `~/.config/gitui/`
    * Link `key_bindings.ron`
