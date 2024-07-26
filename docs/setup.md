# Setup instructions

## 00 - Prerequisites

### Common
* Rust
    * Rationale: Mainly for compiling
* Clang (non-Windows only)
    * Plugin users: Treesiiter
* Zig (Windows only)
    * Plugin users: Treesitter (clang is a pain to setup on Windows)
* Nodejs
    * Plugin users: Lsp
* Nerd Fonts
    * Plugin users: Telescope, lualine, ...
    * Note: If you use wezterm, it already has it.
    * Install: https://www.nerdfonts.com/
* Package manager (Windows: scoop, macOS: brew)
    * Rationale: Mainly for installing common tools

### Core

* Ripgrep
    * Plugin users: Spectre [find & replace], Telescope
    * Install: `cargo install ripgrep`
* Sed
    * Plugin users: Spectre [find & replace], Telescope
    * Install:
        * Windows: `scoop install sed`
        * MacOS: `brew install gnu-sed`
        * Linux: Should be installed by default
* unzip
    * Plugin users: mason-nvim-dap
    * Install:
        * Windows: Should be installed by default
        * Ubuntu:
```sh
sudo apt install unzip
```

## 01 - Install Neovim

(Note: Minimum version required: v0.9.2)

* Windows:

```sh
scoop install neovim
```

* macOS:

```sh
brew install neovim
```

* Ubuntu:

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

Source: https://github.com/neovim/neovim/wiki/Installing-Neovim

### Config - Git

```sh
git config --global core.editor nvim
```

## 02 - Clone mynvim Repo

* Windows

```sh
cd ~/AppData/Local/
git clone git@github.com:yamgent/mynvim.git nvim
```

* Unix

```sh
mkdir -p ~/.config
cd ~/.config
git clone git@github.com:yamgent/mynvim.git nvim
```

