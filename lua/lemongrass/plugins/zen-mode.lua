return {
    "folke/zen-mode.nvim",
    event = "BufRead",
    cmd = { "ZenMode" },
    config = function()
        local zen_mode = require("zen-mode")

        zen_mode.setup({
            window = {
                width = 125,
                backdrop = 0.5,
            },
        })
    end,
}
