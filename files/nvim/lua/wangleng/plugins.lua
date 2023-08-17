----- BOOTSTRAP LAZY.NVIM -----
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Bootstrapping lazy.nvim")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

----- SETUP -----
require("lazy").setup({
    -- Create ending brackets when starting bracket is entered
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- equivalent to: require("nvim-autopairs").setup({})
    },
    -- Git added/modified/removed signs/lines at the line number guide
    {
        'lewis6991/gitsigns.nvim',
        opts = {}
    },
    -- Git lens per line
    {
        'APZelos/blamer.nvim',
        config = function()
            vim.g.blamer_enabled = 1
            vim.g.blamer_prefix = "      ~> "
        end
    },
    -- Ctrl+P file list
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('telescope').setup()
            local keyset = vim.keymap.set

            local project_files = function()
                vim.fn.system('git rev-parse --is-inside-work-tree')
                if vim.v.shell_error == 0 then
                    -- when inside a git repo, this will respect
                    -- gitignore
                    require "telescope.builtin".git_files({
                        show_untracked = true,
                    })
                else
                    require "telescope.builtin".find_files({
                        no_ignore = false,
                        hidden = true,
                    })
                end
            end

            keyset("n", "<C-p>", function() project_files() end, { silent = true })

            -- additional: live grep
            keyset("n", "<leader>F", function() require "telescope.builtin".live_grep() end, { silent = true })
        end,
    },
    -- file browser
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require('telescope')
            local keyset = vim.keymap.set

            telescope.load_extension('file_browser')
            -- show current file's directory
            keyset("n", "<leader>e",
                function() telescope.extensions.file_browser.file_browser({ path = "%:p:h", }) end,
                { silent = true }
            )
            -- show project's root directory
            keyset("n", "<leader>E",
                function() telescope.extensions.file_browser.file_browser() end,
                { silent = true }
            )
        end
    },
    -- colorize HTML color codes, or even basic colors like red
    {
        'NvChad/nvim-colorizer.lua',
        opts = {}
    },
    -- colorize TODO, FIX, etc comments...
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    -- draw guide lines for indents
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            vim.opt.list = true

            require("indent_blankline").setup {
                show_current_context = true,
                show_current_context_start = true,
            }
        end
    },
    -- find and replace
    {
        'windwp/nvim-spectre',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local spectre = require('spectre')
            local keyset = vim.keymap.set
            keyset("n", "<leader>f", function() spectre.open() end)
        end
    },
    -- statusbar
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {}
    },
    -- tpope: surround
    'tpope/vim-surround',
    -- tpope: git
    {
        'tpope/vim-fugitive',
        config = function()
            local keyset = vim.keymap.set
            keyset("n", "<Leader>g", ":Git<CR>")
            -- Don't press <CR>, allowing args to be filled
            keyset("n", "<Leader>G", ":Git<Space>")
        end
    },
    -- tpope: comment
    'tpope/vim-commentary',
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
                    "javascript", "typescript", "tsx", "css", "scss", "html", "vue", "svelte", "json", "yaml",
                    "python",
                    "c",
                    "rust", "toml"
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
    -- lsp
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        },
        config = function()
            local lsp = require('lsp-zero')

            lsp.preset({
                float_border = 'rounded',
                call_servers = 'local',
                configure_diagnostics = true,
                setup_servers_on_start = true,
                set_lsp_keymaps = {
                    preserve_mappings = false,
                    omit = {},
                },
                manage_nvim_cmp = {
                    set_sources = 'recommended',
                    set_basic_mappings = true,
                    set_extra_mappings = false,
                    use_luasnip = true,
                    set_format = true,
                    documentation_window = true,
                },
            })

            lsp.ensure_installed({
                'rust_analyzer',
                'tsserver',
                'eslint',
                'jsonls',
                'cssls',
                'svelte',
                'lua_ls',
            })

            vim.opt.signcolumn = 'yes'

            lsp.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                local keyset = vim.keymap.set
                keyset("n", "<C-k>", function() vim.diagnostic.goto_prev() end, opts)
                keyset("n", "<C-j>", function() vim.diagnostic.goto_next() end, opts)
                keyset("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
                keyset("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)
            end)

            lsp.setup()

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                    format = function(d)
                        local code = d.code or (d.user_data and d.user_data.lsp.code)
                        if code then
                            return string.format("%s [%s]", d.message, code):gsub("1. ", "")
                        end
                        return d.message
                    end,
                },
            })

            -- format on save
            vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

            local cmp = require('cmp')

            cmp.setup({
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }
            })
        end
    },
    -- lsp: fancy symbols in auto-complete
    {
        'onsails/lspkind.nvim',
        dependencies = {
            { 'hrsh7th/nvim-cmp' },
        },
        config = function()
            local lspkind = require('lspkind')
            local cmp = require('cmp')
            cmp.setup {
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text'
                    })
                }
            }
        end
    },
    -- lsp: for prettier (make prettier become an lsp server)
    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettierd
                }
            })
        end
    },
    -- lsp: inlay hints
    {
        'lvimuser/lsp-inlayhints.nvim',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
        },
        config = function()
            require('lsp-inlayhints').setup()

            -- boilerplate setup code for this plugin, to attach
            -- hints once LSP is activated
            vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = "LspAttach_inlayhints",
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end

                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("lsp-inlayhints").on_attach(client, bufnr)
                end,
            })

            -- for typescript inlay hints
            require('lspconfig').tsserver.setup({
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    }
                }
            })
        end
    },

    --- FANCY THEMES!
    -- THEME: gruvbox
    {
        'morhetz/gruvbox',
        config = function()
            -- vim.cmd('colorscheme gruvbox')

            -- some terminal do not support underline, so we must
            -- use background for error/warning highlighting instead :/
            -- NOTE: If your terminal supports underlining, recommend to disable this!
            ---- vim.g.gruvbox_guisp_fallback = 'bg'
        end
    },
    -- THEME: tokyonight
    {
        'folke/tokyonight.nvim',
        config = function()
            -- vim.cmd('colorscheme tokyonight-night')
        end
    },
    -- THEME: vscode
    {
        'Mofiqul/vscode.nvim',
        config = function()
            -- vim.cmd('colorscheme vscode')
        end
    },
    -- THEME: onedark
    {
        'navarasu/onedark.nvim',
        config = function()
            vim.cmd('colorscheme onedark')
        end
    },
    -- THEME: darcula
    {
        'doums/darcula',
        config = function()
            -- vim.cmd('colorscheme darcula')
        end
    },
    -- THEME: seoul256
    {
        'junegunn/seoul256.vim',
        config = function()
            -- vim.g.seoul256_background = 234
            -- vim.cmd('colorscheme seoul256')
        end
    },
    -- THEME: lunar
    {
        'lunarvim/lunar.nvim',
        config = function()
            -- vim.cmd('colorscheme lunar')
        end
    }
})
