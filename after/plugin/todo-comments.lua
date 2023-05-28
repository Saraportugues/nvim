-- todo-comments
local todo = require("todo-comments")
todo.setup({})
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
