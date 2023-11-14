return {
    -- treesitter syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "vim", "lua", "vimdoc",
                    "gitcommit", "gitignore",
                    "javascript", "typescript", "tsx", "css", "scss", "html", "vue", "svelte", "yaml",
                    "json", "jsonc",
                    "python",
                    "c", "cpp", "cmake",
                    "rust", "toml",
                    "go", "gomod",
                    "zig",
                },
                -- install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,
                -- enable highlighting
                highlight = { enable = true },
                -- enable indent behaviour when using '=' operator
                indent = { enable = true },
            })
        end
    },
}
