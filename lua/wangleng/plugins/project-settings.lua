return {
    -- project settings
    {
        "yamgent/simple-settings.nvim",
        config = function()
            local settings = require('simple-settings')

            settings.setup()
            settings.read_config({
                disable_vim_fugitive = false,
                hide_inlay_hints = false,
                disable_format_on_save = false,
            })
        end
    },
}
