-- lazy.nvim default priority is 50
-- lazy.nvim README recommends setting color scheme priority to 1000
local colorSchemePriority = 1000

return {
    {
        'morhetz/gruvbox',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme gruvbox')
        end
    },
    -- THEME: tokyonight
    {
        'folke/tokyonight.nvim',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme tokyonight-night')
        end
    },
    -- THEME: vscode
    {
        'Mofiqul/vscode.nvim',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme vscode')
        end
    },
    -- THEME: onedark
    {
        'navarasu/onedark.nvim',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme onedark')
        end
    },
    -- THEME: kanagawa
    {
        'rebelot/kanagawa.nvim',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            vim.cmd('colorscheme kanagawa')
        end
    },
    -- THEME: darcula
    {
        'doums/darcula',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme darcula')
        end
    },
}
