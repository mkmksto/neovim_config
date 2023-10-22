return {
    "hrsh7th/cmp-cmdline",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        local cmp = require("cmp")

        -- FOR Vim CMD mode
        --
        --
        -- https://github.com/hrsh7th/cmp-cmdline
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline({
                ["<C-j>"] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
                ["<C-k>"] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
                ["<Tab>"] = { c = cmp.mapping.confirm({ select = false }) },
                ["<C-Space>"] = { c = cmp.mapping.complete() }, -- show completion suggestions
            }),
            sources = {
                { name = "buffer" },
            },
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline({
                ["<C-j>"] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
                ["<C-k>"] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
                ["<Tab>"] = { c = cmp.mapping.confirm({ select = false }) },
                ["<C-Space>"] = { c = cmp.mapping.complete() }, -- show completion suggestions
            }),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "Man", "!" },
                    },
                },
            }),
        })
    end,
}
