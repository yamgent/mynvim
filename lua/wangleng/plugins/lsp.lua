return {
    -- lsp
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = function()
            vim.opt.signcolumn = 'yes'
        end
    },
    -- mason: manager for LSP, DAP, formatters, etc...
    {
        'williamboman/mason.nvim',
        opts = {},
    },
    -- mason configuration
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { 'VonHeikemen/lsp-zero.nvim' },
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'rust_analyzer',
                    'ts_ls',
                    'eslint',
                    'jsonls',
                    'cssls',
                    'svelte',
                    'lua_ls',
                    'clangd',
                    'gopls',
                    'zls',
                },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        -- nvim_lua_ls() configures lua_ls to understand neovim config lua
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                    ts_ls = function()
                        -- typescript inlay hints need to be manually enabled
                        require('lspconfig').ts_ls.setup({
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
                }
            })
        end
    },
    -- lsp: auto completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
            },
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                })
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
            lspkind.init({
                mode = 'symbol_text'
            })

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
    -- lsp: formatting
    {
        'stevearc/conform.nvim',
        config = function()
            ---Selects the first available formatter.
            ---
            ---@param bufnr integer
            ---@param ... string
            ---@return string
            local function first(bufnr, ...)
                local conform = require("conform")
                for i = 1, select("#", ...) do
                    local formatter = select(i, ...)
                    if conform.get_formatter_info(formatter, bufnr).available then
                        return formatter
                    end
                end
                return select(1, ...)
            end

            local function select_prettier(bufnr)
                return first(bufnr, "prettierd", "prettier")
            end

            local function use_prettier(bufnr)
                return { select_prettier(bufnr) }
            end

            local function use_web_formatters(bufnr)
                return { "eslint_d", select_prettier(bufnr) }
            end

            require("conform").setup({
                formatters_by_ft = {
                    javascript = use_web_formatters,
                    javascriptreact = use_web_formatters,
                    typescript = use_web_formatters,
                    typescriptreact = use_web_formatters,
                    html = use_prettier,
                    vue = use_web_formatters,
                    svelte = use_web_formatters,
                    json = use_prettier,
                    css = use_web_formatters,
                },
            })

            -- format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function(args)
                    require("conform").format({
                        bufnr = args.buf,
                        -- so that we don't have to manually set it up
                        -- for other languages like rust, go, etc...
                        -- which already know how to format
                        lsp_format = 'fallback',
                    })
                end,
            })
        end
    },
    -- lsp: lsp update messages
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            -- options
        },
    },
    -- lsp: code context breadcrumb
    {
        'SmiteshP/nvim-navic',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
        },
        opts = {
            lsp = {
                auto_attach = true,
            },
        }
    },
}
