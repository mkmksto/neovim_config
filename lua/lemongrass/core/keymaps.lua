local keymap = vim.keymap
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "

-- maintain centered lines
keymap.set("n", "<C-j>", "<C-d>zz")
keymap.set("n", "<C-k>", "<C-u>zz")
keymap.set("n", "{", "{zz")
keymap.set("n", "}", "}zz")

-- Clipboard Image Plugin (paste image command)
keymap.set(
    "n",
    "<leader>ss",
    "<cmd>PasteImg<CR>",
    { desc = "[Clipboard Image] Paste image from clipboard into markdown file", noremap = true, silent = true }
)

-- my remaps
-- keymap.set("i", "<S-space", "<Esc>")
-- keymap.set("i", "<C-j>", "<Esc>o")
keymap.set("n", "<C-Enter>", "o<Esc>", { desc = "Create empty newline" })
keymap.set({ "i", "n", "v" }, "<C-z>", "")
keymap.set("n", " ", "")

-- keymap.set({ "n", "v" }, "<S-j>", "")
keymap.set("n", "<Up>", "")
keymap.set("n", "<Down>", "")
keymap.set("n", "<Left>", "")
keymap.set("n", "<Right>", "")

-- Buffers
keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })
keymap.set("n", "<leader>bd", "<cmd>Bdelete!<CR>", { desc = "[B]uffer - [D]elete from list" })
-- keymap.set("n", "<leader>bd", "<cmd>bdelete!<CR>")

keymap.set({ "n", "i" }, "<C-s>", "<cmd>write<CR>", { desc = "Write to file/save file", noremap = true, silent = true })
-- keymap.set("i", "<C-s>", "", { noremap = true, silent = true })

-- keep cursor in the middle when jumping through search results (https://youtu.be/w7i4amO_zaE?t=1590)
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Resize window
keymap.set("n", "<C-left>", "<C-w>10<", { desc = "Resize window (decrease width)" })
keymap.set("n", "<C-right>", "<C-w>10>", { desc = "Resize window (increase width)" })
keymap.set("n", "<C-up>", "<C-w>6+", { desc = "Resize window (increase height)" })
keymap.set("n", "<C-down>", "<C-w>6-", { desc = "Resize window (decrease height)" })

-- https://youtu.be/vdn_pKJUda8?list=PLTqGJvc0HUn2GY0sW2L61lDuBaXBKnorO&t=1064
keymap.set("n", "x", '"_x') -- do not copy a deleted char to register

-- managing tabs
keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab", noremap = true, silent = true })
keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab", noremap = true, silent = true })
keymap.set("n", "<leader><Tab>", "<cmd>tabn<CR>", { desc = "Next tab", noremap = true, silent = true })
keymap.set("n", "<leader><S-Tab>", "<cmd>tabp<CR>", { desc = "Previous tab", noremap = true, silent = true })

-- nvim tree toglee
keymap.set(
    "n",
    "<C-b>",
    -- "<cmd>NvimTreeToggle<CR>",
    "<cmd>Neotree toggle<CR>",
    { desc = "Toggle File Explorer(NvimTree)", noremap = true, silent = true }
)

---------------------------
---- Move text up and down (https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/keymappings.lua)
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "swap lines" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "swap lines" })
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "swap lines" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "swap lines" })

-- pasting stuff (from prime's vid) (https://youtu.be/w7i4amO_zaE?t=1610)
keymap.set("x", "<leader>p", '"_dP', { desc = "Do not copy singly deleted characters to register" })
keymap.set("n", "Q", "<nop>", { desc = "they said S-q is dangerous, dunno why" })

-- toggles markdown checkboxes
keymap.set(
    "n",
    "<leader>tt",
    "<cmd>lua require('toggle-checkbox').toggle()<CR>",
    { desc = "Toggle markdown checkboxes", noremap = true, silent = true }
)
