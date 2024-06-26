return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "jayp0521/mason-null-ls.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_null_ls = require("mason-null-ls")

        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            -- list of language servers: https://github.com/williamboman/mason-lspconfig.nvim
            ensure_installed = {
                "tsserver",
                "html",
                "cssls",
                "tailwindcss",
                "lua_ls",
                "graphql",
                "emmet_ls",
                "prismals",
                "pyright",
                "bashls",
                "dockerls",
                "jsonls",
                "yamlls",
                -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sqlls
                "sqlls",
                "clangd",
                "texlab",
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })

        -- from here?: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
        mason_null_ls.setup({
            -- list of formatters & linters for mason to install
            ensure_installed = {
                "prettierd",
                "stylua",
                "eslint_d",
                "black",
                "isort",
                "latexindent",
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true,
        })
    end,
}
