return {
    -- https://github.com/Exafunction/codeium.vim
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
        vim.keymap.set("i", "<C-Enter>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true, silent = true }, { desc = "Codeium Accept suggestion" })
    end,
}
