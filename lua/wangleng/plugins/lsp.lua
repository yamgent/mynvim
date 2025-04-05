return {
    -- lsp configuration (mainly through mason)
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            -- mason: manager for LSP, DAP, formatters, etc...
            { 'williamboman/mason.nvim' },

            -- neovim's lspconfig API
            { 'neovim/nvim-lspconfig' },

            -- auto-complete functionality
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },

            -- fancy symbols in auto-complete
            { 'onsails/lspkind.nvim' },

            -- snippet functionality
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            -- reserve a space in the gutter
            -- this will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'yes'

            vim.lsp.inlay_hint.enable()

            -- make hover window (the window when you press K) round bordered
            -- needed because currently Telescope does not handle `vim.opt.winborder = 'rounded'` correctly
            -- so a workaround is to manually override hover instead
            --
            -- might be worth re-visiting this again after
            -- https://github.com/nvim-telescope/telescope.nvim/issues/3436
            -- is fixed
            --
            -- original mynvim's issue: https://github.com/yamgent/mynvim/issues/56
            local hover = vim.lsp.buf.hover
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.lsp.buf.hover = function()
                return hover({
                    border = "rounded"
                })
            end

            -- setup basic keymaps for lsp
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local opts = { buffer = args.buf, remap = false }
                    local keyset = vim.keymap.set
                    keyset("n", "<C-k>", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
                    keyset("n", "<C-j>", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)

                    keyset("n", "<C-h>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, opts)
                    keyset("i", "<C-h>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, opts)

                    keyset("n", "gl", function() vim.diagnostic.open_float() end, opts)

                    -- the default nvim keybindings for gd and gD does not use LSP capabilities
                    -- hence, if you try to gd a library's type/method, it does not navigate
                    -- to the library's source code, since without LSP, nvim does not know
                    -- how to go to the library's source code
                    --
                    -- fix this by overriding the keybindings to use LSP
                    keyset('n', 'gd', function() vim.lsp.buf.definition() end, opts)
                    keyset('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
                end
            })

            vim.diagnostic.config({
                -- for all lines, just show the error at the back
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

            -- for fancy symbols in auto-complete
            local lspkind = require('lspkind')
            lspkind.init({
                mode = 'symbol_text'
            })

            -- setup auto-complete
            local cmp = require('cmp')
            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                },
                snippet = {
                    expand = function(args)
                        -- LuaSnip snippets functionality
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text'
                    })
                }
            })

            -- important: need to init mason before init mason-lspconfig
            require('mason').setup({})

            local lspconfig = require('lspconfig')

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            local lspconfig_defaults = lspconfig.util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lspconfig_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

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
                    -- default handler
                    function(server_name)
                        lspconfig[server_name].setup({})
                    end,
                    lua_ls = function()
                        local runtime_path = vim.split(package.path, ';')
                        table.insert(runtime_path, 'lua/?.lua')
                        table.insert(runtime_path, 'lua/?/init.lua')

                        -- lua_opts configures lua_ls to understand neovim config lua
                        local lua_opts = {
                            settings = {
                                Lua = {
                                    -- Disable telemetry
                                    telemetry = { enable = false },
                                    runtime = {
                                        -- Tell the language server which version of Lua you're using
                                        -- (most likely LuaJIT in the case of Neovim)
                                        version = 'LuaJIT',
                                        path = runtime_path,
                                    },
                                    diagnostics = {
                                        -- Get the language server to recognize the `vim` global
                                        globals = { 'vim' }
                                    },
                                    workspace = {
                                        checkThirdParty = false,
                                        library = {
                                            -- Make the server aware of Neovim runtime files
                                            vim.fn.expand('$VIMRUNTIME/lua'),
                                            vim.fn.stdpath('config') .. '/lua'
                                        }
                                    }
                                }
                            }
                        }

                        lspconfig.lua_ls.setup(lua_opts)
                    end,
                    ts_ls = function()
                        -- typescript inlay hints need to be manually enabled
                        lspconfig.ts_ls.setup({
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
