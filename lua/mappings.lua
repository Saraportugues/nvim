local keymap = vim.keymap
local api = vim.api

-- move cursor keys one key to the right
keymap.set({"n", "v", "o"}, "j", "h")
keymap.set({"n", "v", "o"}, "k", "j")
keymap.set({"n", "v", "o"}, "l", "k")
keymap.set({"n", "v", "o"}, "ç", "l")

-- Scroll
keymap.set({"n", "v"}, "K", "<C-e>")
keymap.set({"n", "v"}, "L", "<C-y>")
keymap.set({"n", "v"}, "<C-k>", "<C-d>")
keymap.set({"n", "v"}, "<C-l>", "<C-u>")

-- move <C-w> to jklç
keymap.set({"n"}, "<C-w>j", "<C-w>h")
keymap.set({"n"}, "<C-w>k", "<C-w>j")
keymap.set({"n"}, "<C-w>l", "<C-w>k")
keymap.set({"n"}, "<C-w>ç", "<C-w>l")


-- telescope
local builtin = require("telescope.builtin")
keymap.set("n", "<C-e>", builtin.find_files, {})

