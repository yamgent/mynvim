# Usage

## Block vim-fugitive

When using neovim on a big repo (e.g. monorepos), vim-fugitive has a tendency
to freeze, due to git status taking very long and vim-fugitive not being async.

For those cases, it is preferable to block vim-fugitive. You can do that by
doing the following:

```sh
git config --local --add vim.blockfugitive 1
```
