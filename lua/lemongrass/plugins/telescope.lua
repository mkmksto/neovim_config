local current_os = vim.loop.os_uname().sysname
-- On my PC, vim.loop.os_uname().sysname evalues to Windows_NT instead of just Windows
local is_win = string.find(current_os, "Windows")

local deps
if is_win then
    deps = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
    }
else
    deps = {
        "nvim-lua/plenary.nvim",
        -- fzf native is causing windows problems for some reason
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    }
end

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = deps,
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")

        -----------------------
        --
        -- Cusotm Telescope finders
        -- https://www.youtube.com/watch?v=hQSZEZeZIPk
        -- TODO

        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local sorters = require("telescope.sorters")

        -- -- project files
        -- vim.keymap.set("n", "<C-p>", builtin.find_files, {})
        -- -- fuzzy finding (git file search)
        -- vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
        --
        -- something similar @ remap.lua (except that one only searches inside files, this one includes the file names)
        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        -- live grep over all of my projects and notes
        vim.keymap.set("n", "<leader>nts", function()
            builtin.live_grep({
                search_dirs = { "~/Documents/Github-repos/", "~/Documents/notes/", "~/Documents/reference-repos/" },
            })
        end, {
            desc = "[Telescope] Search through all of my repos, reference repos and notes (live grep, live_grep)",
        })

        -- live grep over the python docs (searches for functions)
        vim.keymap.set("n", "<leader>pfun", function()
            builtin.live_grep({
                search_dirs = {
                    "~/.config/telescope_programming_docs/library_python/",
                    "~/.config/telescope_programming_docs/python3-2022/",
                },
                default_text = "^",
            })
        end, {
            desc = "[Telescope] Search inside the python docs (particularly [F]unctions) (live grep, live_grep)",
        })

        -- live grep over the python docs (searches for functions)
        vim.keymap.set("n", "<leader>jfun", function()
            builtin.live_grep({
                search_dirs = { "~/.config/telescope_programming_docs/mdn-2022/" },
                default_text = "^",
            })
        end, { desc = "[Telescope] Search inside the MDN JS docs (live grep, live_grep)" })

        local keymap = vim.keymap

        keymap.set(
            "n",
            "<leader>?",
            "<cmd>Telescope oldfiles<cr>",
            { desc = "[Telescope] Recently opened files (old files)" }
        )

        keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 3,
                previewer = false,
                layout_config = { width = 0.6 },
            }))
        end, { desc = "[Telescope] Search inside current buffer/file" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "[Telescope] Grep inside files" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "[Telescope] Grep word under cursor" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "[Telescope] - List Buffers" })

        keymap.set("n", "<C-S-p>", "<cmd>Telescope keymaps<cr>", { desc = "[Telescope] - show all Keymaps" })

        keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "[Telescope] - Find Files" })

        -- file search over python docs (each file is a text file/python builtin std lib)
        keymap.set("n", "<leader>pdoc", function()
            builtin.find_files({
                search_dirs = {
                    "~/.config/telescope_programming_docs/library_python/",
                    "~/.config/telescope_programming_docs/python3-2022/",
                },
            })
        end, { desc = "[Telescope] Search for python modules (kw=docs/documentation, find files)" })

        -- file search over python docs (each file is a text file/python builtin std lib)
        -- https://terokarvinen.com/2022/ks-kanasirja-offline-tui-dictionary/
        keymap.set("n", "<leader>jdoc", function()
            builtin.find_files({
                search_dirs = { "~/.config/telescope_programming_docs/mdn-2022/" },
            })
        end, {
            desc = "[Telescope] Search for JS/MDN modules/functions/global builtins (kw=docs/documentation, find files)",
        })

        -- file search over TLDR
        keymap.set("n", "<leader>tldr", function()
            builtin.find_files({
                search_dirs = { "~/.config/telescope_programming_docs/tldr-2022/" },
            })
        end, { desc = "[Telescope] TLDR docs(terminal, bash, linux, mac, windows)" })

        keymap.set("n", "<leader>gf", "<cmd>Telescope git_files<CR>", { desc = "[Telescope] git files" })
        keymap.set(
            "n",
            "<leader>tman",
            "<cmd>Telescope man_pages<CR>",
            { desc = "[Telescope] Search through the linux man pages" }
        ) -- linux man pages
        keymap.set("n", "<leader>tgs", "<cmd>Telescope git_status<CR>", { desc = "[Telescope] git status" })
        keymap.set(
            "n",
            "<leader>thelp",
            "<cmd>Telescope help_tags<CR>",
            { desc = "[Telescope] Search through telescope's help manual " }
        )

        -- keymap.set("n", "<leader>trg", "<cmd>Telescope live_grep_args<CR>")
        -- keymap.set("n", "<leader>trg", '<cmd>Telescope live_grep_args search_dirs={"~/Documents/Github-repos/"}<CR>')

        -- Telescope LSP stuff
        keymap.set("n", "<leader>tgf", "<cmd>Telescope lsp_references<CR>", { desc = "[Telescope] LSP References" })
        keymap.set(
            "n",
            "<leader>tgi",
            "<cmd>Telescope lsp_implementations<CR>",
            { desc = "[Telescope] LSP Implementations" }
        )
        keymap.set("n", "<leader>tgd", "<cmd>Telescope lsp_definitions<CR>", { desc = "[Telescope] LSP Definitions" })
        keymap.set(
            "n",
            "<leader>tT",
            "<cmd>Telescope lsp_type_definitions<CR>",
            { desc = "[Telescope] LSP Type Definition" }
        )

        keymap.set(
            "n",
            "<leader>tcmd",
            "<cmd>Telescope commands<CR>",
            { desc = "[Telescope] list all available vim commands(including plugins)" }
        )

        ------------------------
        --
        -- TELESCOPE SETUP
        --
        --
        --
        --
        --
        telescope.setup({
            defaults = {
                -- https://github.com/nvim-telescope/telescope.nvim/issues/895
                path_display = { "truncate" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
                -- Note: you can use a .ignore file at the root of your project so that
                -- telescope will not search through it
                -- https://github.com/nvim-telescope/telescope.nvim/issues/522#issuecomment-1107441677
                -- https://github.com/BurntSushi/ripgrep/issues/673
                file_ignore_patterns = {
                    "static",
                    "templates",
                    "**/pnpm%-lock.yaml",
                    "**/package%-lock.json",
                    "dictionary_files",
                    -- ".json",
                    "package.json",
                    "**/package.json",
                    "pnpm-lock.yaml",
                    "**/pnpm-lock.yaml",
                    "package-lock.json",
                    "**/package-lock.json",
                    -- ".yaml",
                    ".ico",
                    ".jpg",
                    ".jpeg",
                    ".png",
                    ".gif",
                    ".svg",
                },
            },
            -- doesn't work
            extensions = {
                live_grep_args = {
                    list = {
                        search_dirs = { "~/Documents/Github-repos" },
                    },
                },
                repo = {
                    list = {
                        search_dirs = { "~/Documents/Github-repos", "~/Documents/notes", "~/Documents/reference-repos" },
                    },
                },
            },
        })

        if is_win then
            print("is windows")
        else
            print("is not windows")
            telescope.load_extension("fzf")
        end
        -- telescope.load_extension("neoclip")
        -- telescope.load_extension("repo")
    end,
}
