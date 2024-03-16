return {
    "lervag/vimtex",
    init = function()
        -- Use init for configuration, don't use the more common "config".
    end,
    config = function()
        -- https://github.com/Neelfrost/nvim-config/blob/main/lua/user/plugins/config/vimtex.lua
        -- https://ejmastnak.com/tutorials/vim-latex/compilation/#vimtex
        vim.g.vimtex_view_method = "zathura"
    end,
}
