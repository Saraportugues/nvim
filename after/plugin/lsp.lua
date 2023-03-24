vim.opt.signcolumn = 'yes' -- Reserve space for diagnostic icons

local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
    "rust_analyzer",
    "clangd",
    "lua_ls",
    "bashls",
})

local cmp = require("cmp")
local cmp_select = {
    behavior = cmp.SelectBehavior.Select
}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.definition, bufopts) -- fd -> function definition
    vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>v", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<leader>gh", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts) -- r -> rename
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, bufopts) -- a -> action
    vim.keymap.set("n", "<leader>u", vim.lsp.buf.references, bufopts) -- u -> usages
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, bufopts)
end)

lsp.nvim_workspace()

lsp.setup()
