-- SETUP --
-- tree-sitter
require("nvim-treesitter.configs").setup( {
	highlight = {
		enable = true,
	}
})

-- sticky headers
require'treesitter-context'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
        },
        -- Patterns for specific filetypes
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        tex = {
            'chapter',
            'section',
            'subsection',
            'subsubsection',
        },
        rust = {
            'impl_item',
            'struct',
            'enum',
        },
        scala = {
            'object_definition',
        },
        vhdl = {
            'process_statement',
            'architecture_body',
            'entity_declaration',
        },
        markdown = {
            'section',
        },
        elixir = {
            'anonymous_function',
            'arguments',
            'block',
            'do_block',
            'list',
            'map',
            'tuple',
            'quoted_content',
        },
        json = {
            'pair',
        },
        yaml = {
            'block_mapping_pair',
        },
        c = {
            "do",
        },
        cpp = {
            "do",
        },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
}

require("telescope").setup{}
-- require("telescope").load_extension("harpoon")
-- 
-- require("harpoon").setup {
--     global_settings = {
--         mark_branch = true,
--     }
-- }


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
  vim.keymap.set("n", "<space>dd", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "<space>fd", vim.lsp.buf.definition, bufopts) -- fd -> function definition
  vim.keymap.set("n", "<space>td", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>p", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<space>i", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<space>h", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, bufopts) -- r -> rename
  vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts) -- a -> action
  vim.keymap.set("n", "<space>u", vim.lsp.buf.references, bufopts) -- u -> usages
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
    "bashls",
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
