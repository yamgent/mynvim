# Usage

## Block vim-fugitive

When using neovim on a big repo (e.g. monorepos), vim-fugitive has a tendency
to freeze, due to git status taking very long and vim-fugitive not being async.

For those cases, it is preferable to block vim-fugitive. You can do that by
adding the following to `~/.config/simple-settings/settings.json`

```json
{
    "<...path to project>": {
        "disable_vim_fugitive": true
    }
}
```

> Note: If you did not use the block and encounter the freezing issue, you can 
> also just use `<C-c>` to interrupt vim-fugitive and stop the freeze.

## Hide inlay hints on start

In `~/.config/simple-settings/settings.json`

```json
{
    "<...path to project>": {
        "hide_inlay_hints": true
    }
}
```

## Disable formatting on save

In `~/.config/simple-settings/settings.json`

```json
{
    "<...path to project>": {
        "disable_format_on_save": true
    }
}
```

## Customize quick postfix for telescope grep

Useful for cases where the project may have a standard set of ignores for
example.

Access the quick postfix with `<C-c>` when telescope grep is active.

In `~/.config/simple-settings/settings.json`

```json
{
    "<...path to project>": {
        "telescope_grep_quick_postfix": " --iglob '!README.md'"
    }
}
```
