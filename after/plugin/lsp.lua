local vim = vim -- just so the lsp shuts up
local keymap = vim.keymap
local vlsp = vim.lsp

vim.opt.signcolumn = "yes" -- Reserve space for diagnostic icons

local lsp_zero = require("lsp-zero")
lsp_zero.preset("recommended")


lsp_zero.on_attach(function(_, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    keymap.set("n", "<leader>gd", vlsp.buf.declaration, bufopts)
    keymap.set("n", "<leader>gf", vlsp.buf.definition, bufopts) -- fd -> function definition
    keymap.set("n", "<leader>gt", vlsp.buf.type_definition, bufopts)
    keymap.set("n", "<leader>gh", vlsp.buf.signature_help, bufopts)

    keymap.set("n", "<leader>v", vlsp.buf.hover, bufopts)
    keymap.set("n", "<leader>i", vlsp.buf.implementation, bufopts)
    keymap.set("n", "<leader>r", vlsp.buf.rename, bufopts)      -- r -> rename
    keymap.set("n", "<leader>a", vlsp.buf.code_action, bufopts) -- a -> action
    keymap.set("n", "<leader>u", vlsp.buf.references, bufopts)  -- u -> usages
    keymap.set("n", "<leader>h", function()
        vim.diagnostic.open_float()
    end)

    keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

    keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, bufopts)
end)

lsp_zero.setup({
    sources = {
        { name = "path",     keyword_length = 1 },
        { name = "nvim_lsp", keyword_length = 1 },
        { name = "buffer",   keyword_length = 3 },
        { name = "luasnip",  keyword_length = 1 },
    }
})

-- CMP CONFIG

local cmp = require("cmp")

local cmp_select = {
    behavior = cmp.SelectBehavior.Select
}

local cmp_mappings = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),

    ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    }),
})

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp_mappings,
    sources = {
        { name = "nvim_lsp" },
    },
})

-- MASON CONFIG

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {},
    handlers = {
        lsp_zero.default_setup,
    },
})
