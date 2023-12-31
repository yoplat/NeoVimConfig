local plugins = {
	-- Basic dependency
	"nvim-lua/plenary.nvim",
	-- Themes
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		opts = function()
			return require("plugins.configs.themes").catppuccin
		end,
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd("colorscheme catppuccin")
		end,
	},
	{
		"folke/tokyonight.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		opts = function()
			return require("plugins.configs.themes").tokyonight
		end,
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd("colorscheme tokyonight")
		end,
	},
	-- File Explorer
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle" },
		config = function()
			require("plugins.configs.nvimtree")
		end,
	},
	-- Statusline, Bufferline, Winbar
	{
		"rebelot/heirline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.configs.heirline")
		end,
	},
	{
		"Bekaboo/dropbar.nvim", -- TODO: check against navic
		event = "BufReadPre",
		opts = function()
			return require("plugins.configs.dropbar")
		end,
	},
	-- Don't go over the 80 char
	{
		"Bekaboo/deadcolumn.nvim",
		event = "BufReadPost",
		opts = {},
	},
	-- icons, for UI related plugins
	{
		"nvim-tree/nvim-web-devicons",
		opts = {
			strict = true,
			override_by_extension = {
				["norg"] = {
					icon = "",
					color = "#f1502f",
					name = "Neorg",
				},
			},
		},
	},
	-- syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.configs.treesitter")
		end,
	},
	-- highlight word under cursor
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local opts = require("plugins.configs.lsp").illuminate
			require("illuminate").configure(opts)
		end,
	},
	-- UI
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		opts = {},
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	{
		"nmac427/guess-indent.nvim",
		event = "BufReadPre",
		opts = {},
	},
	{
		"stevearc/dressing.nvim", -- TODO: check if needs to be loaded earlier
		opts = function()
			return require("plugins.configs.noice").dressing
		end,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
	{
		"folke/noice.nvim",
		enabled = true,
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = function()
					return require("plugins.configs.noice").notify
				end,
			},
		},
		opts = function()
			return require("plugins.configs.noice").noice
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = function()
			require("plugins.configs.whichkey")
		end,
	},
	-- Terminal
	{
		"akinsho/toggleterm.nvim",
		cmd = "ToggleTerm",
		keys = {
			{
				"<leader>gg",
				"<cmd>lua _LAZYGIT_TOGGLE()<cr>",
				desc = "Lazygit",
			},
		},
		config = function()
			require("plugins.configs.toggleterm")
		end,
	},
	-- Don't open a new neovim instance inside toggleterm when opening files
	{
		"willothy/flatten.nvim",
		opts = function()
			return require("plugins.configs.flatten")
		end,
		lazy = false,
		priority = 1001,
	},
	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- cmp sources
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
			"folke/neodev.nvim",

			-- Copilot
			{
				"zbirenbaum/copilot.lua",
				enabled = true,
				cmd = "Copilot",
				event = "InsertEnter",
				config = function()
					require("plugins.configs.copilot")
				end,
			},

			-- snippets engine
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},

			-- autopairs , autocompletes ()[] etc
			{
				"windwp/nvim-autopairs",
				config = function()
					require("nvim-autopairs").setup()

					--  cmp integration
					local cmp_autopairs = require("nvim-autopairs.completion.cmp")
					local cmp = require("cmp")
					cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
			},
		},
		config = function()
			require("plugins.configs.cmp")
		end,
	},
	-- Install lsp servers
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = { "Mason", "MasonInstall" },
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
	-- lsp
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.configs.lspconfig")
		end,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
	},
	-- formatting
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			return require("plugins.configs.formatter")
		end,
	},
	-- lsp progress
	{
		"j-hui/fidget.nvim",
		tag = "legacy", -- NOTE: check when this is updated
		event = "LspAttach",
		opts = function()
			return require("plugins.configs.lsp").fidget
		end,
	},
	-- Error list
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependenckes = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			return require("plugins.configs.trouble")
		end,
	},
	-- TODO: comments
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			return require("plugins.configs.todo")
		end,
	},
	-- indent lines
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			return require("plugins.configs.others").blankline
		end,
		config = function(_, opts)
			require("indent_blankline").setup(opts)
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	-- files finder etc
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("plugins.configs.telescope")
		end,
	},
	{
		"nvim-neorg/neorg",
		ft = "norg",
		build = ":Neorg sync-parsers",
		cmd = "Neorg",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.concealer"] = {}, -- Adds pretty icons to your documents
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = "~/Notes",
							},
							default_workspace = "notes",
						},
					},
				},
			})
		end,
	},
	-- git status on signcolumn etc
	{
		"lewis6991/gitsigns.nvim",
		ft = { "gitcommit", "diff" },
		init = function()
			-- load gitsigns only when a git file is opened
			vim.api.nvim_create_autocmd({ "BufRead" }, {
				group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
				callback = function()
					vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
					if vim.v.shell_error == 0 then
						vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
						vim.schedule(function()
							require("lazy").load({ plugins = { "gitsigns.nvim" } })
						end)
					end
				end,
			})
		end,
		opts = function()
			return require("plugins.configs.others").gitsigns
		end,
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		cmd = "Spectre",
		opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
	},
	-- comment plugin
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gcc", mode = "n", desc = "Comment toggle current line" },
			{ "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
			{ "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
			{ "gbc", mode = "n", desc = "Comment toggle current block" },
			{ "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
			{ "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
		},
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},
	{
		"folke/flash.nvim",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "o", "x" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
	},
	-- Measure startuptime
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 100
		end,
	},
	-- Embed tmux into statusline
	-- {
	-- 	"vimpostor/vim-tpipeline",
	-- 	event = "VeryLazy",
	-- },
}

require("lazy").setup(plugins, require("plugins.configs.lazy"))
