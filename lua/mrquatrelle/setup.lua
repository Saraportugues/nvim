local api = vim.api

-- highlight yanked region, see `:h lua-highlight`
api.nvim_create_autocmd({ "TextYankPost" }, {
    pattern = "*",
    group = api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 250 }
    end,
})

-- Resize all windows when we resize the terminal
api.nvim_create_autocmd("VimResized", {
    group = api.nvim_create_augroup("win_autoresize", { clear = true }),
    desc = "autoresize windows on resizing operation",
    command = "wincmd =",
})

-- Automatically reload the file if it is changed outside of Nvim.
api.nvim_create_augroup("auto_read", { clear = true })

api.nvim_create_autocmd({ "FileChangedShellPost" }, {
    pattern = "*",
    group = "auto_read",
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded!",
            vim.log.levels.WARN, { title = "nvim-config" })
    end,
})
