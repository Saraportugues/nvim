local keymap = vim.keymap

local telescope = require("telescope")

telescope.setup({
    pickers = {
        find_files = {
            find_command = { "fdfind", "--type", "f", "--hidden", "--strip-cwd-prefix", "--exclude", ".git" },
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

vim.keymap.set("n", "<M-n>", function()
    if vim.fn.expand("%") == "" then
        telescope.extensions.file_browser.file_browser()
    else
        vim.cmd("Telescope file_browser path=%:p:h select_buffer=true<CR>")
    end
end)
