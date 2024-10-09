local keymap = vim.keymap

keymap.set("n", "<leader>c", ":RustLsp renderDiagnostic current<CR>")
