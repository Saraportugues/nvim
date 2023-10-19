local keymap = vim.keymap

require("telescope").setup({
    pickers = {
        find_files = {
            find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix", "--exclude", ".git" },
        },
    }

})

local builtin = require("telescope.builtin")

keymap.set("n", "<M-e>", builtin.find_files, {})
keymap.set("n", "<leader>ps", function()
    builtin.grep_string({
        search = vim.fn.input(" Search > ")
    })
end)
