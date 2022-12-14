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
keymap.set({"n"}, "<C-w>J", "<C-w>H")
keymap.set({"n"}, "<C-w>K", "<C-w>J")
keymap.set({"n"}, "<C-w>L", "<C-w>K")
keymap.set({"n"}, "<C-w>Ç", "<C-w>L")


-- telescope
local builtin = require("telescope.builtin")
keymap.set("n", "<C-e>", builtin.find_files, {})

-- harpoon
local ui = require("harpoon.ui")
local mark = require("harpoon.mark")

keymap.set({"n"}, "<M-a>", function() mark.add_file() end)
keymap.set({"n"}, "<M-h>", function() ui.toggle_quick_menu() end)
keymap.set({"n"}, "<M-1>", function() ui.nav_file(1) end)
keymap.set({"n"}, "<M-2>", function() ui.nav_file(2) end)
keymap.set({"n"}, "<M-3>", function() ui.nav_file(3) end)
keymap.set({"n"}, "<M-4>", function() ui.nav_file(4) end)
keymap.set({"n"}, "<M-5>", function() ui.nav_file(5) end)
keymap.set({"n"}, "<M-6>", function() ui.nav_file(6) end)
keymap.set({"n"}, "<M-7>", function() ui.nav_file(7) end)
keymap.set({"n"}, "<M-8>", function() ui.nav_file(8) end)
keymap.set({"n"}, "<M-9>", function() ui.nav_file(9) end)
keymap.set({"n"}, "<M-0>", function() ui.nav_file(10) end)


-- todo-comments
todo = require("todo-comments")

vim.keymap.set("n", "<M-t>", function()
        todo.jump_next()
    end,
    { desc = "Next todo comment" })

vim.keymap.set("n", "<M-T>", function()
        todo.jump_prev()
    end,
    { desc = "Previous todo comment" })

vim.keymap.set("n", "<Space>t", function()
        vim.cmd("TodoTelescope")
    end,
    { desc = "Open list of todo's on Telescope" })

