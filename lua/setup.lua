-- SETUP --
-- tree-sitter
require("nvim-treesitter.configs").setup( {
	highlight = {
		enable = true,
	}
})

require("treesitter-context").setup({})

require("tokyonight").setup({
	style = "night",
	transparent = "true",
    sidebars = { "packer" },
    on_colors = function(colors)
        colors.red = "#EE4B2B"
        colors.green = "#32CD30"
        colors.blue = "#5294E3"   
    end,
    on_highlights = function(hl, c)
        hl.Boolean = {fg = c.red}
        hl.Operator = {fg = c.orange}
        hl.Keyword = {fg = c.orange}
        hl.LineNr = {fg = c.blue, bg = "#121212"}
        hl.Type = {fg = c.orange}
        hl.Conditional = {fg = c.orange}
        hl.Repeat = {fg = c.orange}
        hl.Label = {fg = c.orange}
        hl.ColorColumn = {bg = c.dark5}

    end,
})
vim.cmd("colorscheme tokyonight")

-- lualine
require("lualine").setup( {
	theme = "tokyonight",
    sections = {
        lualine_x = {"encoding", "filetype"},
    },
})

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item()
                end
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        {
            name = "luasnip",
            options = {
                show_autosnippets = true,
            },
        },
        {
            name = "nvim_lsp",
        },
    },
})

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gp", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local servers = {
    "pyright",
    "rust_analyzer",
    "jdtls",
    "clangd",
}
for _, lsp in pairs(servers) do
    require("lspconfig")[lsp].setup {
        on_attach = on_attach,
        flags = lsp_flags,
    }
end

require("neogen").setup({
    snippet_engine = "luasnip",
})

vim.cmd("set colorcolumn=100") -- set a ruler at 100 characters
