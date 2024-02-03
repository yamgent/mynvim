return {
    -- dap
    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap = require('dap')

            vim.fn.sign_define('DapBreakpoint', { text = '' })

            -- shortcuts
            local keyset = vim.keymap.set
            keyset('n', '<F5>', function() dap.continue() end)
            keyset('n', '<F6>', function() dap.terminate() end)
            keyset('n', '<F9>', function() dap.step_into() end)
            keyset('n', '<F10>', function() dap.step_over() end)
            keyset('n', '<F11>', function() dap.step_out() end)
            keyset('n', '<Leader>db', function() dap.toggle_breakpoint() end)
            keyset('n', '<Leader>dB', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
            keyset('n', '<Leader>dlp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
            keyset('n', '<Leader>dl', function() dap.run_last() end)

            -- backup shortcuts in case F keys not readily available (e.g Mac with Touch Bar :/)
            keyset('n', '<Leader>dr', function() dap.continue() end)
            keyset('n', '<Leader>de', function() dap.terminate() end)
            keyset('n', '<Leader>di', function() dap.step_into() end)
            keyset('n', '<Leader>ds', function() dap.step_over() end)
            keyset('n', '<Leader>do', function() dap.step_out() end)
        end
    },
    -- dap: user interface
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap' },
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')

            dapui.setup()

            -- hook for opening/closing dapui when debugging
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            local keyset = vim.keymap.set
            keyset('n', '<Leader>duo', function() dapui.open() end)
            keyset('n', '<Leader>duc', function() dapui.close() end)
        end
    },
    -- dap: install common adapters
    {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = {
            { 'williamboman/mason.nvim' },
            { 'mfussenegger/nvim-dap' },
        },
        config = function()
            require('mason-nvim-dap').setup({
                ensure_installed = { "delve", "codelldb" }
            })

            local dap = require('dap')

            ---- adapters
            -- lldb
            local lldb_cmd = vim.fn.stdpath("data") .. '/mason/packages/codelldb/codelldb'
            if vim.fn.has('win32') == 1 then
                lldb_cmd = vim.fn.stdpath("data") .. '/mason/packages/codelldb/extension/adapter/codelldb.exe'
            end

            dap.adapters.lldb = {
                type = 'server',
                port = "${port}",
                name = 'lldb',
                executable = {
                    command = lldb_cmd,
                    args = { "--port", "${port}" },

                    -- On windows you may have to uncomment this:
                    -- detached = false,
                }
            }

            ---- languages
            dap.configurations.rust = {
                {
                    name = "Launch lldb",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ",
                            vim.fn.getcwd() .. "/",
                            "file"
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    args = {},
                    runInTerminal = false,
                }
            }
        end
    },
}
