vim.lsp.inlay_hint.enable()

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { buffer = args.buf, remap = false }
        local keyset = vim.keymap.set
        keyset("n", "<C-k>", function() vim.diagnostic.jump({ count = -1 }) end, opts)
        keyset("n", "<C-j>", function() vim.diagnostic.jump({ count = 1 }) end, opts)

        keyset("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        keyset("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        keyset("n", "gl", function() vim.diagnostic.open_float() end, opts)
    end
})

vim.diagnostic.config({
    -- for all lines, just show the error at the back
    virtual_text = true,
    virtual_lines = {
        -- only show virtual line diagnostics for the current cursor line
        current_line = true,
    },
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        format = function(d)
            local code = d.code or (d.user_data and d.user_data.lsp.code)
            if code then
                return string.format("%s [%s]", d.message, code):gsub("1. ", "")
            end
            return d.message
        end,
    },
})
