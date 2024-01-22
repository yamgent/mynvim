return {
    -- tpope: git
    {
        'tpope/vim-fugitive',
        config = function()
            local keyset = vim.keymap.set

            local git_local_config = vim.fn.system("git config --local --list")
            local allow_fugitive = string.find(git_local_config, "vim.blockfugitive=1") == nil

            if allow_fugitive then
                keyset("n", "<Leader>g", ":Git<CR>")
                -- Don't press <CR>, allowing args to be filled
                keyset("n", "<Leader>G", ":Git<Space>")
            else
                keyset("n", "<Leader>g", function()
                    print("Fugitive is blocked due to vim.blockfugitive=1 configured in git")
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

