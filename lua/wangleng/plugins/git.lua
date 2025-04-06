return {
    -- tpope: git
    {
        'tpope/vim-fugitive',
        dependencies = { "yamgent/simple-settings.nvim" },
        config = function()
            local settings = require('simple-settings')
            local keyset = vim.keymap.set

            local allow_fugitive = not settings.get_field("disable_vim_fugitive")

            if allow_fugitive then
                keyset("n", "<Leader>g", ":Git<CR>")
                -- Don't press <CR>, allowing args to be filled
                keyset("n", "<Leader>G", ":Git<Space>")
            else
                keyset("n", "<Leader>g", function()
                    print("Fugitive is blocked for this project")
                end)
            end
        end
    },
    -- Git added/modified/removed signs/lines at the line number guide
    -- and git lens blame
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            current_line_blame = true,
        },
    },
}
