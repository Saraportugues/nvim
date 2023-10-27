local vim = vim -- so the ls doesn't complain

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-CR>", "copilot#Accept('<CR>')", {
    silent = true,
    expr = true
})

vim.cmd("Copilot disable")
