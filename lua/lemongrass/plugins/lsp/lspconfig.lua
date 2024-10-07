return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        -- { "antosha417/nvim-lsp-file-operations", config = true }, -- rename files through neotree and update affected imports
        "jose-elias-alvarez/typescript.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local typescript = require("typescript")

        local keymap = vim.keymap

        local on_attach = function(client, bufnr)
            -- keybind options
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- set keybinds
            keymap.set(
                "n",
                "gf",
                "<cmd>Lspsaga finder<CR>",
                { desc = "[Lspsaga] LSP Finder(definition, references, implementation(if there are any)" },
                opts
            )
            -- keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration (essentially a less good version of Lspsaga goto_definition, can be buggy)
            keymap.set("n", "gP", "<cmd>Lspsaga peek_definition<CR>", { desc = "[Lspsaga] Peek definition" }, opts) -- see definition and make edits in window
            keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<CR>", { desc = "[Lspsaga] go to definiton" }, opts)
            keymap.set(
                "n",
                "gi",
                "<cmd>lua vim.lsp.buf.implementation()<CR>",
                { desc = "[vim.lsp.buf](LSP) go to implementation" },
                opts
            )
            keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "[Lspsaga] code action" }, opts)
            keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "[Lspsaga] rename" }, opts)
            keymap.set(
                "n",
                "<leader>D",
                "<cmd>Lspsaga show_line_diagnostics<CR>",
                { desc = "[Lspsaga] show diagnostics" },
                opts
            )
            keymap.set(
                "n",
                "<leader>dd",
                "<cmd>Lspsaga show_cursor_diagnostics<CR>",
                { desc = "[Lspsaga] show diagnostic under cursor" },
                opts
            )
            keymap.set(
                "n",
                "[d",
                "<cmd>Lspsaga diagnostic_jump_prev<CR>",
                { desc = "[Lspsaga] jump through diagnostics" },
                opts
            )
            keymap.set(
                "n",
                "]d",
                "<cmd>Lspsaga diagnostic_jump_next<CR>",
                { desc = "[Lspsaga] jump through diagnostics" },
                opts
            ) -- jump to next diagnostic in buffer
            keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "[Lspsaga] show hover documentation" }, opts)
            keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

            -- typescript specific keymaps (e.g. rename file and update imports)
            if client.name == "tsserver" then
                keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
                keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
                keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
            end
        end

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- configure html server
        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- -- configure typescript server with plugin
        -- lspconfig["tsserver"].setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        -- })
        --
        -- note: this is a plugin
        typescript.setup({
            disable_commands = false, -- prevent the plugin from creating Vim commands
            debug = false, -- enable debug logging for commands
            go_to_source_definition = {
                fallback = true, -- fall back to standard LSP definition on failure
            },
            server = {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = {
                    "typescriptreact",
                    "javascriptreact",
                    "typescript",
                    "javascript",
                },
            },
        })

        -- configure css server
        lspconfig["cssls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure tailwindcss server
        lspconfig["tailwindcss"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure prisma orm server
        lspconfig["prismals"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure graphql language server
        lspconfig["graphql"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })

        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })

        -- configure python server
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            before_init = function(_, config)
                -- reference
                -- https://github.com/zazencodes/zazencodes-youtube/blob/main/src/neovim-lazy-ide-2024/.config/nvim/lua/plugins/lazy.lua#L156
                print("inside before_init")
                local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
                local python_path

                if venv_path then
                    python_path = venv_path .. "/bin/python3"
                else
                    -- python_path = vim.fn.exepath("python3") or vim.fn.exepath("python")
                    python_path = vim.fn.exepath("python3")
                end

                -- Set pythonPath for Pyright
                config.settings.python.pythonPath = python_path

                -- Print the Python path Pyright will use
                print("Pyright is using Python interpreter at:", python_path)

                -- client.notify("workspace/didChangeConfiguration")
            end,
            -- on_init = function(client)
            --     -- before_init = function(client)
            --     local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
            --     local python_path
            --
            --     if venv_path then
            --         python_path = venv_path .. "/bin/python"
            --     else
            --         python_path = vim.fn.exepath("python3") or vim.fn.exepath("python")
            --     end
            --
            --     -- Set pythonPath for Pyright
            --     client.config.settings.python.pythonPath = python_path
            --
            --     -- Print the Python path Pyright will use
            --     print("Pyright is using Python interpreter at:", python_path)
            --
            --     client.notify("workspace/didChangeConfiguration")
            -- end,
        })

        lspconfig["bashls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["dockerls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["jsonls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["yamlls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["sqlls"].setup({
            cmd = { "sql-language-server", "up", "--method", "stdio" },
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = function()
                return vim.loop.cwd()
            end,
        })

        lspconfig["clangd"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["texlab"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = { -- custom settings for lua
                Lua = {
                    -- make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- make language server aware of runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
    end,
}
