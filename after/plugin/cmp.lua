local cmp_autopairs = require("nvim-autopairs.completion.cmp")

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
        behavior = cmp.ConfirmBehavior.Insert,
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

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)
