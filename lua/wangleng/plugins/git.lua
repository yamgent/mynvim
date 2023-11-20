return {
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
    -- Git added/modified/removed signs/lines at the line number guide
    {
        -- TODO: Check whether `lewis6991/gitsigns.nvim` fixed the attach issue
        -- https://github.com/lewis6991/gitsigns.nvim/issues/903
        'yamgent/gitsigns.nvim',
        branch = 'fix-gitsigns-attach',
        opts = {
            current_line_blame = true,
        },
    },
}
