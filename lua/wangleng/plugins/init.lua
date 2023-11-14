return {
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
    -- statusbar
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            -- for 'winbar' (and inactive_winbar) options, it is only used by
            -- nvim-navic, so can get rid of 'winbar' options if we are
            -- no longer using breadcrumbs
            winbar = {
                lualine_b = { 'filename' },
                lualine_c = { "require'nvim-navic'.get_location()" }
            },
            inactive_winbar = {
                lualine_b = { 'filename' },
            }
        }
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
}
