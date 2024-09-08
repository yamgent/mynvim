return {
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
            },
            sections = {
                lualine_c = {
                    {
                        'filename',
                        -- mainly for oil.nvim (otherwise we just see "[No Name]")
                        -- anyway the default nvim also shows relative path
                        path = 1
                    },
                },
            }
        }
    },
}
