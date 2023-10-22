local current_os = vim.loop.os_uname().sysname
local is_win = string.find(current_os, "Windows")

return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            local toggleterm = require("toggleterm")

            toggleterm.setup({
                -- size can be a number or function which is passed the current terminal
                size = 20,
                open_mapping = [[<c-\>]],
                hide_numbers = true, -- hide the number column in toggleterm buffers
                persist_size = true,
                direction = "horizontal",
                close_on_exit = true,
                start_in_insert = true,
                shell = is_win and '"C:\\Program Files\\Git\\bin\\bash.exe"' or vim.o.shell,
                auto_scroll = true,
            })

            function _G.set_terminal_keymaps()
                local opts = { noremap = true }
                vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
                vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><Cmd>wincmd h<CR>]], opts)
                vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><Cmd>wincmd l<CR>]], opts)
            end

            -- https://stackoverflow.com/questions/13511084/vim-set-cursor-position-in-command-line
            -- vim.keymap.set("n", "<leader>`", ":ToggleTerm direction=horizontal auto_scroll=true<C-Left><C-Left><Left>") -- unnecessary, just to 2<C-\>, etc.
            vim.keymap.set(
                { "n", "t" },
                "<C-`>",
                "<Esc><C-\\><C-n><cmd>ToggleTermToggleAll<CR>",
                { desc = "[Toggleterm] Toggle all terminals" }
            )
            -- vim.keymap.set("n", "<leader>lz", ":LazyGit<CR>")

            vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

            local Terminal = require("toggleterm.terminal").Terminal

            -- !IMPORTANT NOTE:
            -- Having the `count = <number>` things are necessary, otherwise, the terminals devour your open terminals
            local python = Terminal:new({ cmd = "python3", hidden = true, direction = "float", count = 6 })
            function _PYTHON_TOGGLE()
                python:toggle()
            end
            vim.keymap.set(
                "n",
                "<leader>tpy",
                ":lua _PYTHON_TOGGLE()<CR>",
                { desc = "[Toggleterm] Toggle Python floating terminal" }
            )

            local node_js = Terminal:new({ cmd = "node", hidden = true, direction = "float", count = 7 })
            function _NODE_TOGGLE()
                node_js:toggle()
            end
            vim.keymap.set(
                "n",
                "<leader>tjs",
                ":lua _NODE_TOGGLE()<CR>",
                { desc = "[Toggleterm] Toggle NODE JS floating terminal" }
            )

            local floating_term = Terminal:new({ hidden = true, direction = "float", close_on_exit = true, count = 5 })
            function _FLOATING_TOGGLE()
                floating_term:toggle()
            end
            vim.keymap.set(
                "n",
                "<leader>fl",
                ":lua _FLOATING_TOGGLE()<CR>",
                { desc = "[Toggleterm] Toggle floating terminal" }
            )

            local htop = Terminal:new({ cmd = "htop", hidden = true, direction = "float", count = 8 })
            function _HTOP_TOGGLE()
                htop:toggle()
            end
            vim.keymap.set(
                "n",
                "<leader>htop",
                ":lua _HTOP_TOGGLE()<CR>",
                { desc = "[Toggleterm] Toggle floating HTOP terminal" }
            )

            local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float", count = 9 })
            function _LAZYGIT_TOGGLE()
                lazygit:toggle()
            end
            vim.keymap.set(
                "n",
                "<leader>lz",
                ":lua _LAZYGIT_TOGGLE()<CR>",
                { desc = "[Toggleterm] Toggle floating Lazygit terminal" }
            )
        end,
    },
}
