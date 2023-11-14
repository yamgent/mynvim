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
    -- tpope: surround
    'tpope/vim-surround',
    -- tpope: comment
    'tpope/vim-commentary',
}
