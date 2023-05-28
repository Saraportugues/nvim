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
        hl.Boolean = { fg = c.red }
        hl.Operator = { fg = c.orange }
        hl.Keyword = { fg = c.orange }
        hl.LineNr = { fg = c.blue }
        hl.Type = { fg = c.orange }
        hl.Conditional = { fg = c.orange }
        hl.Repeat = { fg = c.orange }
        hl.Label = { fg = c.orange }
        hl.ColorColumn = { bg = c.dark5 }
    end,
})
vim.cmd("colorscheme tokyonight")
