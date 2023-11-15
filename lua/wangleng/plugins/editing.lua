return {
    -- Create ending brackets when starting bracket is entered
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- equivalent to: require("nvim-autopairs").setup({})
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
        main = "ibl",
        config = function()
            vim.opt.list = true

            require("ibl").setup {
                indent = { char = "▏" },
            }
        end
    },
    -- tpope: surround
    'tpope/vim-surround',
    -- tpope: comment
    'tpope/vim-commentary',
}
