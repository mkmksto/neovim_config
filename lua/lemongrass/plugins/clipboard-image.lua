return {
    -- https://github.com/ekickx/clipboard-image.nvim/issues/50#issuecomment-1589856732
    "dfendr/clipboard-image.nvim",
    -- "ekickx/clipboard-image.nvim",
    ft = { "markdown" },
    -- markdown = {
    --     img_dir = { "%:p:h", ".img" },
    --     img_dir_txt = "./.img",
    -- },
    config = function()
        local setup, clip_image = pcall(require, "clipboard-image")
        if not setup then
            return
        end

        clip_image.setup({
            markdown = {
                img_dir = { "%:p:h", ".img" },
                img_dir_txt = "./.img",
            },
        })
    end,
}
