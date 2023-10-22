return {
    "glepnir/lspsaga.nvim",
    config = function()
        local saga = require("lspsaga")

        saga.setup({
            -- keybinds for navigation in lspsaga window
            move_in_saga = { prev = "<C-k>", next = "<C-j>" },
            -- use enter to open file with finder
            finder_action_keys = {
                open = "<CR>",
            },
            -- use enter to open file with definition preview
            definition_action_keys = {
                edit = "<CR>",
            },
            ui = {
                border = "rounded",
            },
        })

        vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
        -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
        vim.diagnostic.config({
            severity_sort = true,
            virtual_text = {
                prefix = "●", -- Could be '●', '▎', 'x'
            },
        })
    end,
}
