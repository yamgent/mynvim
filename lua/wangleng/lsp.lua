vim.lsp.inlay_hint.enable()

vim.diagnostic.config({
    -- for all lines, just show the error at the back
    virtual_text = true,
    virtual_lines = {
        -- only show virtual line diagnostics for the current cursor line
        current_line = true,
    },
})
