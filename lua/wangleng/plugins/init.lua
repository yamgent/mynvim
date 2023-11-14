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
}
