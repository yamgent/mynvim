return {
    -- treesitter syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local is_win32 = vim.fn.has('win32') == 1

            if is_win32 then
                -- on Windows, it is a pain to set up clang properly
                require("nvim-treesitter.install").compilers = { "zig" }
            end

            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "vim", "lua", "vimdoc",
                    "gitcommit", "gitignore",
                    "javascript", "typescript", "tsx", "css", "scss", "html", "vue", "svelte", "yaml", "jsdoc",
                    "json", "jsonc",
                    "python",
                    "c", "cpp", "cmake",
                    "rust", "toml",
                    "go", "gomod",
                    "zig",
                    "odin",
                },
                -- install parsers synchronously (only applied to `ensure_installed`)
                -- zig can only install synchronously, async install somehow have problems
                -- (and since Windows is using zig, have to disable async install, which is the default)
                sync_install = is_win32,
                -- enable highlighting
                highlight = { enable = true },
                -- enable indent behaviour when using '=' operator
                indent = { enable = true },
            })
        end
    },
}
