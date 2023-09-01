local keymap = vim.keymap
local api = vim.api

vim.g.mapleader = " "

-- move cursor keys one key to the right
keymap.set({ "n", "v", "o" }, "j", "h")
keymap.set({ "n", "v", "o" }, "k", "j")
keymap.set({ "n", "v", "o" }, "l", "k")
keymap.set({ "n", "v", "o" }, "ç", "l")
keymap.set({ "n", "v", "o" }, ";", "l")

-- move <C-w> to jklç
keymap.set({ "n" }, "<C-w>j", "<C-w>h")
keymap.set({ "n" }, "<C-w>k", "<C-w>j")
keymap.set({ "n" }, "<C-w>l", "<C-w>k")
keymap.set({ "n" }, "<C-w>ç", "<C-w>l")
keymap.set({ "n" }, "<C-w>;", "<C-w>l")
keymap.set({ "n" }, "<C-w>J", "<C-w>H")
keymap.set({ "n" }, "<C-w>K", "<C-w>J")
keymap.set({ "n" }, "<C-w>L", "<C-w>K")
keymap.set({ "n" }, "<C-w>Ç", "<C-w>L")
keymap.set({ "n" }, "<C-w>:", "<C-w>L")

keymap.set({ "n" }, "<M-j>", "<C-w>h")
keymap.set({ "n" }, "<M-k>", "<C-w>j")
keymap.set({ "n" }, "<M-l>", "<C-w>k")
keymap.set({ "n" }, "<M-ç>", "<C-w>l")
keymap.set({ "n" }, "<M-;>", "<C-w>l")
keymap.set({ "n" }, "<M-J>", "<C-w>H")
keymap.set({ "n" }, "<M-K>", "<C-w>J")
keymap.set({ "n" }, "<M-L>", "<C-w>K")
keymap.set({ "n" }, "<M-Ç>", "<C-w>L")
keymap.set({ "n" }, "<M-:>", "<C-w>L")
