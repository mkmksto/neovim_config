return {
    "jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- import null-ls plugin
        local null_ls = require("null-ls")

        local null_ls_utils = require("null-ls.utils")

        -- for conciseness
        local formatting = null_ls.builtins.formatting -- to setup formatters
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters

        -- to setup format on save
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        -- configure null_ls
        null_ls.setup({
            -- add package.json as identifier for root (for typescript monorepos)
            root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
            -- setup formatters & linters
            sources = {
                --  to disable file types use
                --  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
                formatting.prettierd,
                formatting.latexindent,
                formatting.stylua,
                formatting.black,
                formatting.isort,
                -- diagnostics.pylint,
                diagnostics.pylint.with({
                    command = function()
                        local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
                        local python_path
                        local pylint_path

                        if venv_path then
                            python_path = venv_path .. "/bin/python"
                            pylint_path = venv_path .. "/bin/pylint"
                        else
                            python_path = vim.fn.exepath("python") or vim.fn.exepath("python3")
                            pylint_path = vim.fn.exepath("pylint")
                        end

                        if pylint_path and vim.fn.executable(pylint_path) == 1 then
                            return pylint_path
                        elseif python_path and vim.fn.executable(python_path) == 1 then
                            return python_path .. " -m pylint"
                        else
                            return nil
                        end
                    end,
                    condition = function(utils)
                        return utils.root_has_file({ "pyproject.toml", "setup.py", "setup.cfg", ".pylintrc", ".git" })
                    end,
                }),

                diagnostics.eslint_d.with({ -- js/ts linter
                    condition = function(utils)
                        return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
                    end,
                }),
            },
            -- configure format on save
            on_attach = function(current_client, bufnr)
                if current_client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                filter = function(client)
                                    --  only use null-ls for formatting instead of lsp server
                                    return client.name == "null-ls"
                                end,
                                bufnr = bufnr,
                            })
                        end,
                    })
                end
            end,
        })
    end,
}
