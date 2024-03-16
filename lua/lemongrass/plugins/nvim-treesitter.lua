local current_os = vim.loop.os_uname().sysname
local is_win = string.find(current_os, "Windows")

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "windwp/nvim-ts-autotag",
        },
        config = function()
            -- import nvim-treesitter plugin
            local treesitter = require("nvim-treesitter.configs")

            -- configure treesitter
            treesitter.setup({
                -- A list of parser names, or "all"
                ensure_installed = {
                    "javascript",
                    "typescript",
                    "lua",
                    "json",
                    "toml",
                    "markdown",
                    "markdown_inline",
                    "svelte",
                    "vue",
                    "bash",
                    "vim",
                    "css",
                    "tsx",
                },
                -- https://www.lazyvim.org/plugins/treesitter
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = is_win and "@" or "<C-space>",
                        node_incremental = is_win and "@" or "<C-space>",
                        scope_incremental = "<nop>",
                        node_decremental = "<bs>",
                    },
                },

                indent = { enable = true },

                autotag = { enable = true },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,
                    disable = { "latex" },

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                    config = {
                        javascript = {
                            __default = "// %s",
                            --[[ jsx_element = "{/* %s */}", ]]
                            jsx_fragment = "{/* %s */}",
                            jsx_attribute = "// %s",
                            comment = "// %s",
                        },
                    },
                },
            })
        end,
    },
}
