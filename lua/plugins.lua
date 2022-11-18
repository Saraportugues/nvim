return require("packer").startup(function(use)
	-- make packer manage itself
	use {
		"wbthomason/packer.nvim",
	}
	use {
		"folke/tokyonight.nvim",
	}
	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim"
		},
	}
	use {
		"nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
	}
	use {
		"nvim-treesitter/nvim-treesitter-context",
	}
	use {
		"lewis6991/impatient.nvim",
	}
	use {
  		"nvim-lualine/lualine.nvim",
  		requires = {"kyazdani42/nvim-web-devicons", opt = true }
    }
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "onsails/lspkind-nvim",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        }
    }
    use {
        "neovim/nvim-lspconfig",
    }
    use {
        "mfussenegger/nvim-jdtls",
    }
    use {
        "danymat/neogen",
    }
end)

