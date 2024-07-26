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
    -- lsp: glue code
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })

                local opts = { buffer = bufnr, remap = false }
                local keyset = vim.keymap.set
                keyset("n", "<C-k>", function() vim.diagnostic.goto_prev() end, opts)
                keyset("n", "<C-j>", function() vim.diagnostic.goto_next() end, opts)
                keyset("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
                keyset("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)

                keyset("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                keyset("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end)

            -- need to be called after extend_lspconfig(), otherwise the diagnostic display doesn't work
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
                    'tsserver',
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
                    tsserver = function()
                        -- typescript inlay hints need to be manually enabled
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
                'VonHeikemen/lsp-zero.nvim',
            },
        },
        config = function()
            local lsp_zero = require('lsp-zero')

            lsp_zero.extend_cmp({
                set_sources = 'recommended',
                set_basic_mappings = true,
                set_extra_mappings = false,
                use_luasnip = true,
                set_format = true,
                documentation_window = true,
            })

            local cmp = require('cmp')

            cmp.setup({
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
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
    -- lsp: inlay hints UI
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
