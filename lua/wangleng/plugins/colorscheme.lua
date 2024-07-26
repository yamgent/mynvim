-- lazy.nvim default priority is 50
-- lazy.nvim README recommends setting color scheme priority to 1000
local colorSchemePriority = 1000

return {
    {
        'sainnhe/gruvbox-material',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            vim.cmd('colorscheme gruvbox-material')
        end
    },
    {
        'folke/tokyonight.nvim',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme tokyonight-night')
        end
    },
    {
        'Mofiqul/vscode.nvim',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme vscode')
        end
    },
    {
        'navarasu/onedark.nvim',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme onedark')
        end
    },
    {
        'rebelot/kanagawa.nvim',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme kanagawa')
        end
    },
    {
        'doums/darcula',
        priority = colorSchemePriority,
        lazy = false,
        config = function()
            -- vim.cmd('colorscheme darcula')
        end
    },
}
