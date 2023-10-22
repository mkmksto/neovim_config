local current_os = vim.loop.os_uname().sysname
local is_win = string.find(current_os, "Windows")

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 400 })
    end,
})

-- local yanks = vim.api.nvim_create_augroup("yanks", { clear = true })
-- local yank_ns = vim.api.nvim_create_namespace("hlyank")
-- vim.api.nvim_create_autocmd("TextYankPost", {
--     pattern = { "*" },
--     callback = function(args)
--         local pos1 = vim.fn.getpos("'[")
--         local pos2 = vim.fn.getpos("']")
--         local event = vim.v.event
--
--         pos1 = { pos1[2] - 1, pos1[3] - 1 + pos1[4] }
--         pos2 = { pos2[2] - 1, pos2[3] - 1 + pos2[4] }
--
--         vim.highlight.range(
--             args.buf,
--             yank_ns,
--             "Visual",
--             pos1,
--             pos2,
--             { priority = 200, inclusive = event.inclusive, regtype = event.regtype }
--         )
--     end,
-- })

-- local clear_hl = function(event)
--     vim.api.nvim_create_autocmd(event, {
--         pattern = { "*" },
--         group = yanks,
--         callback = function(args)
--             vim.api.nvim_buf_clear_namespace(args.buf, yank_ns, 0, -1)
--         end,
--     })
-- end

-- clear_hl("TextChanged")
-- -- clear_hl("InsertEnter")

-- vim.keymap.set("n", "<Esc>", function()
--     if yank_ns then
--         print(yank_ns)
--         vim.api.nvim_buf_clear_namespace(0, yank_ns, 0, -1)
--     end
-- end, { noremap = true })

-- https://github.com/craftzdog/dotfiles-public/blob/master/.config/nvim/lua/craftzdog/base.lua
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.shell = is_win and "cmd.exe" or "zsh"

-- ignore case if lowercase, but will not if something is uppercased
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true

-- backups, swaps, etc https://youtu.be/jGAAnrOF2mQ?list=PLTqGJvc0HUn2GY0sW2L61lDuBaXBKnorO
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.swapfile = false

-- line numbers + relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.linebreak = true
-- vim.opt.wrapmargin = 20
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.wrap = true

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
-- vim.opt.viewoptions = "folds,cursor"
vim.opt.title = true
-- https://github.com/F-Robot/dotfiles/blob/master/.config/nvim/lua/settings.lua
vim.opt.breakindent = true -- Wrapped lines will be visually indented with same amount of space.

-- when searching do not keep things highlighted, enable incremental search
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 12
vim.opt.ttyfast = true

-- https://youtu.be/hY5-Q6NxQgY?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ&t=296
vim.opt.splitbelow = true -- horizontal splits go below
vim.opt.splitright = true -- vertical splits go right

-- https://youtu.be/vdn_pKJUda8?list=PLTqGJvc0HUn2GY0sW2L61lDuBaXBKnorO&t=523
-- appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- backspace
vim.opt.backspace = "indent,eol,start"

-- from devaslife
vim.opt.cmdheight = 1

-- for comment remaps
vim.opt.timeoutlen = 1000

-- https://www.reddit.com/r/neovim/comments/rb3ac1/how_can_i_remove_the_symbol/
vim.opt.fillchars:append({ eob = " " })

-- folding
-- https://unix.stackexchange.com/questions/141097/how-to-enable-and-use-code-folding-in-vim
-- vim.opt.foldmethod = "syntax"
-- vim.opt.foldnestmax = 10
-- vim.opt.foldnestmax = 10
-- vim.opt.nofoldenable = true
-- vim.opt.foldlevel = 2
