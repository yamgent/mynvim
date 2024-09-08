return {
    -- Ctrl+P file list
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('telescope').setup()
            local keyset = vim.keymap.set

            local project_files = function()
                require "telescope.builtin".find_files({
                    find_command = {
                        'rg', '--files',    -- use ripgrep files list
                        '--color', 'never', -- telescope by default pass this
                        '-L',               -- follow symlinks
                        '--hidden',         -- show dotfiles...
                        '-g', '!.git/**'    -- ...but don't show '.git/' folder!
                    }
                })
            end

            keyset("n", "<C-p>", function() project_files() end, { silent = true })

            -- additional: live grep
            keyset("n", "<leader>f", function()
                require "telescope.builtin".live_grep({
                    layout_strategy = 'vertical',
                })
            end, { silent = true })

            -- additional: search word under cursor
            keyset("n", "<leader>F", function()
                require "telescope.builtin".grep_string({
                    layout_strategy = 'vertical',
                })
            end, { silent = true })

            -- additional: symbol searches
            keyset("n", "<leader>qs", function() require "telescope.builtin".lsp_document_symbols() end)
            keyset("n", "<leader>qS", function() require "telescope.builtin".lsp_workspace_symbols() end)

            -- additional: help searches
            keyset("n", "<leader>qh", function() require "telescope.builtin".help_tags() end)

            -- additional: commands
            keyset("n", "<leader>qp", function() require "telescope.builtin".commands() end)
        end,
    },
    -- better algorithm for Ctrl-P
    {
        "natecraddock/telescope-zf-native.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").load_extension("zf-native")
        end
    },
    -- file browser
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                keymaps = {
                    ["<C-p>"] = false,
                    ["<C-y>"] = "actions.preview",
                }
            })

            local keyset = vim.keymap.set
            keyset("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (oil)", silent = true })
        end,
    },
    -- file browser (floating)
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require('telescope')
            local keyset = vim.keymap.set

            telescope.load_extension('file_browser')
            -- show current file's directory
            keyset("n", "<leader>qe",
                function() telescope.extensions.file_browser.file_browser({ path = "%:p:h", }) end,
                { silent = true }
            )
            -- show project's root directory
            keyset("n", "<leader>qE",
                function() telescope.extensions.file_browser.file_browser() end,
                { silent = true }
            )
        end
    },
    -- tree browser (floating)
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                    },
                    hijack_netrw_behavior = "disabled",
                    window = {
                        mappings = {
                            ["h"] = "close_node",
                            ["l"] = "open",
                        },
                    },
                },
            })

            local keyset = vim.keymap.set
            keyset("n", "<Leader>t", ":Neotree float reveal<CR>", { silent = true })
            keyset("n", "<Leader>T", ":Neotree float<CR>", { silent = true })
        end
    },
    -- find and replace
    {
        'windwp/nvim-spectre',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local keyset = vim.keymap.set
            keyset("n", "<leader>qf", function() require('spectre').open() end)
        end
    },
    -- file jump list (harpoon)
    {
        "ThePrimeagen/harpoon",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local keyset = vim.keymap.set
            keyset("n", "<Leader>h", function() require("harpoon.mark").add_file() end)
            keyset("n", "<Leader>H", function() require("harpoon.ui").toggle_quick_menu() end)
            keyset("n", "\\", function() require("harpoon.ui").nav_file(vim.v.count1) end)
        end
    },
}
