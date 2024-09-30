return {
    -- "Shatur/neovim-ayu",
    "catppuccin/nvim",
    -- "ghifarit53/tokyonight-vim",
    priority = 1000,
    config = function()
        -- vim.cmd.colorscheme("ayu-mirage")
        vim.cmd.colorscheme("catppuccin-macchiato")
        -- vim.cmd.colorscheme("tokyonight")
    end,
}

-- return {
--     "tiagovla/tokyodark.nvim",
--     opts = {
--         -- custom options here
--     },
--     config = function(_, opts)
--         require("tokyodark").setup(opts) -- calling setup is optional
--         vim.cmd([[colorscheme tokyodark]])
--     end,
-- }
