---
-- Most parts are adapted from Fatih's dptfiles: https://github.com/fatih/dotfiles
---

------------------------------------------------------------------------------------------------------------------------
-- Initialize
------------------------------------------------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then ---@diagnostic disable-line: undefined-field
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local diag_format = function(d)
	return string.format("[%s] %s", d.code, d.message)
end

vim.diagnostic.config({
	virtual_text = {
		format = diag_format,
	},
	float = {
		format = diag_format,
	},
	start_on = false,
})

------------------------------------------------------------------------------------------------------------------------
-- Plugins
------------------------------------------------------------------------------------------------------------------------

require("lazy").setup({
	-- L3MON4D3/LuaSnip
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end
	},

	-- Rawnly/gist.nvim
	{
		"Rawnly/gist.nvim",
		cmd = { "GistCreate", "GistCreateFromFile", "GistsList" },
		config = true,
	},

	-- Wansmer/treesj
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = { "<Space>m", "<Space>j", "<Space>s" },
		config = function()
			require("treesj").setup({
				-- none
			})
		end,
	},

	-- WhoIsSethDaniel/toggle-lsp-diagnostics.nvim
	{
		"WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
		config = function()
			require("toggle_lsp_diagnostics").init(vim.diagnostic.config())
		end,
	},


	-- bronson/vim-visual-star-search
	{
		"bronson/vim-visual-star-search"
	},

	-- direnv/direnv.vim
	{
		"direnv/direnv.vim"
	},

	-- ethanholz/nvim-lastplace
	{
		"ethanholz/nvim-lastplace",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
				lastplace_open_folds = true,
			})
		end,
	},

	-- folke/todo-comments.nvim
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- folke/trouble.nvim
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
		},
		config = function()
			vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
			vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
			vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
			vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
			vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
			vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
		end,

	},

	-- folke/neodev.nvim
	{
		"folke/neodev.nvim",
		opts = {}
	},

	-- gbbrod/nord.nvim
	{
		"gbprod/nord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nord").setup({})
			vim.cmd.colorscheme("nord")
		end,
	},

	-- ggandor/lightspeed.nvim
	{
		"ggandor/lightspeed.nvim"
	},

	-- hrsh7th/nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind-nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			luasnip.config.setup {}

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			require("cmp").setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				formatting = {
					format = lspkind.cmp_format {
						with_text = true,
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							nvim_lua = "[Lua]",
						},
					},
				},
				mapping = cmp.mapping.preset.insert {
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm { select = true },
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				-- don't auto select item
				preselect = cmp.PreselectMode.None,
				window = {
					documentation = cmp.config.window.bordered(),
				},
				view = {
					entries = {
						name = "custom",
						selection_order = "near_cursor",
					},
				},
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Insert,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer",  keyword_length = 5 },
				},
			})
		end,
	},

	-- iamcco/markdown-preview.nvim
	{
		"iamcco/markdown-preview.nvim",
		dependencies = {
			"zhaozg/vim-diagram",
			"aklt/plantuml-syntax",
		},
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		ft = "markdown",
		cmd = { "MarkdownPreview" },
	},

	-- junegunn/vim-easy-align
	{
		"junegunn/vim-easy-align",
	},

	-- lukas-reineke/headlines.nvim
	{
		"lukas-reineke/headlines.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		cond = false,  -- didnt play well with the current colorscheme plugin, waiting to be fixed
		config = function()
			require("headlines").setup({
				markdown = {
					headline_highlights = {
						"Headline1",
						"Headline2",
						"Headline3",
						"Headline4",
						"Headline5",
						"Headline6",
					},
					codeblock_highlight = "CodeBlock",
					dash_highlight = "Dash",
					quote_highlight = "Quote",
				},
			})
		end,
	},

	-- lukas-reineke/indent-blankline.nvim
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
			vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
			vim.g.indent_blankline_char_highlight = "LineNr"
			vim.g.indent_blankline_show_trailing_blankline_indent = false

			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require "ibl.hooks"
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			require("ibl").setup {
				indent = { highlight = highlight },
				enabled = false
			}
		end,
	},

	-- numToStr/Comment.nvim
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},

	-- nvim-lualine/lualine.nvim
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "nord",
					section_separators = { "", "" },
					component_separators = { "", "" },
					disabled_filetypes = {},
				},
				sections = {
					lualine_a = { "mode", "paste" },
					lualine_b = {
						{ "branch", icon = "" },
						{
							"diff",
							color_added = "#a7c080",
							color_modified = "#ffdf1b",
							color_removed = "#ff6666"
						},
					},
					lualine_c = {
						{ "diagnostics", sources = { "nvim_diagnostic" } },
						function()
							return "%="
						end,
						"filename",
					},
					lualine_x = { "filetype" },
					lualine_y = {
						{
							"progress",
						},
					},
					lualine_z = {
						{
							"location",
							icon = "",
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
	},

	-- nvim-telescope/telescope.nvim
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("telescope").setup({
				extensions = {
					fzf = {
						fuzzy = true,
					},
				},
			})

			-- To get fzf loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("fzf")

			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},

	-- nvim-telescope/telescope-fzf-native.nvim
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},

	-- nvim-telescope/telescope-ui-select.nvim
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},

	-- nvim-treesitter/nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go",
					"gomod",
					"lua",
					"ruby",
					"vimdoc",
					"vim",
					"bash",
					"fish",
					"markdown",
					"markdown_inline",
					"mermaid",
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<space>",
						node_incremental = "<space>",
						node_decremental = "<bs>",
						scope_incremental = "<tab>",
					},
				},
				autopairs = {
					enable = true,
				},
				highlight = {
					enable = true,

					-- Disable slow treesitter highlight for large files
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["iB"] = "@block.inner",
							["aB"] = "@block.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]]"] = "@function.outer",
						},
						goto_next_end = {
							["]["] = "@function.outer",
						},
						goto_previous_start = {
							["[["] = "@function.outer",
						},
						goto_previous_end = {
							["[]"] = "@function.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>sn"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>sp"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},

	-- rgroli/other.nvim
	{
		"rgroli/other.nvim",
		config = function()
			require("other-nvim").setup({
				mappings = {
					"rails", --builtin mapping
					{
						pattern = "(.*).go$",
						target = "%1_test.go",
						context = "test",
					},
					{
						pattern = "(.*)_test.go$",
						target = "%1.go",
						context = "file",
					},
					{
						pattern = "(.*).sevgi$",
						target = "%1.sevgi",
						context = "script",
					},
					{
						pattern = "(.*).svg$",
						target = "%1.svg",
						context = "output",
					},
				},
			})

			vim.api.nvim_create_user_command("A", function(opts)
				require("other-nvim").open(opts.fargs[1])
			end, { nargs = "*" })

			vim.api.nvim_create_user_command("AV", function(opts)
				require("other-nvim").openVSplit(opts.fargs[1])
			end, { nargs = "*" })

			vim.api.nvim_create_user_command("AS", function(opts)
				require("other-nvim").openSplit(opts.fargs[1])
			end, { nargs = "*" })
		end,
	},

	-- roktas/turkish.nvim
	{
		"roktas/turkish.nvim",
		config = function()
			require("turkish").defaults()
		end,
		branch = "edge",
	},

	-- samjwill/nvim-unception
	{
		"samjwill/nvim-unception",
		lazy = false,
		init = function()
			vim.g.unception_block_while_host_edits = true
		end,
	},

	-- vifm/vifm.vim
	{
		"vifm/vifm.vim",
	},

	-- windwp/nvim-autopairs
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})
		end,
	},

	------------------------------------------------------------------------------------------------------------------------
	--- Language Server Protocol Settings
	------------------------------------------------------------------------------------------------------------------------

	-- neovim/nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- General

			local lspconfig = require("lspconfig")

			local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol
				.make_client_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
					vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					vim.keymap.set({ "n", "x" }, "gf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
					vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

					vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
					vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
					vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
				end
			})

			local cmp = require("cmp")

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				mapping = cmp.mapping.preset.insert({
					-- Enter key confirms completion item
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					-- Ctrl + space triggers completion menu
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
			})

			-- Bash

			lspconfig.bashls.setup({})

			-- Crystal

			lspconfig.crystalline.setup({})

			-- Javascript

			lspconfig.biome.setup({
				cmd = { "biome-kludge",	"lsp-proxy" }
			})

			-- Go

			lspconfig.gopls.setup({
				capabilities = capabilities,
				flags = { debounce_text_changes = 200 },
				settings = {
					gopls = {
						usePlaceholders = true,
						gofumpt = true,
						analyses = {
							nilness = true,
							unusedparams = true,
							unusedwrite = true,
							useany = true,
						},
						codelenses = {
							gc_details = false,
							generate = true,
							regenerate_cgo = true,
							run_govulncheck = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							vendor = true,
						},
						experimentalPostfixCompletions = true,
						completeUnimported = true,
						staticcheck = true,
						directoryFilters = { "-.git", "-node_modules" },
						semanticTokens = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			})

			-- Lua

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT"
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								vim.env.VIMRUNTIME,
							}
						},
					}
				},


			})

			-- Python

			lspconfig.pylsp.setup({
				settings = {
					pylsp = {
						plugins = {
							pylint = {
								enabled = true,
								executable = "pylint",
							},
						},
					},
				},
			})

			-- Ruby

			local _timers = {}

			local function setup_ruby_ls_diagnostics(client, buffer)
				if require("vim.lsp.diagnostic")._enable then
					return
				end

				local diagnostic_handler = function()
					local params = vim.lsp.util.make_text_document_params(buffer)
					client.request("textDocument/diagnostic", { textDocument = params },
						function(err, result)
							if err then
								local err_msg = string.format("diagnostics error - %s",
									vim.inspect(err))
								vim.lsp.log.error(err_msg)
							end
							if not result then
								return
							end
							vim.lsp.diagnostic.on_publish_diagnostics(
								nil,
								vim.tbl_extend("keep", params,
									{ diagnostics = result.items }),
								{ client_id = client.id },
								{}
							)
						end)
				end

				diagnostic_handler() -- to request diagnostics on buffer when first attaching

				vim.api.nvim_buf_attach(buffer, false, {
					on_lines = function()
						if _timers[buffer] then
							vim.fn.timer_stop(_timers[buffer])
						end
						_timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
					end,
					on_detach = function()
						if _timers[buffer] then
							vim.fn.timer_stop(_timers[buffer])
						end
					end,
				})
			end

			lspconfig.ruby_ls.setup({
				cmd = { "bundle-kludge", "exec", "ruby-lsp" },
				on_attach = function(client, buffer)
					setup_ruby_ls_diagnostics(client, buffer)
				end,
			})

			-- Markdown

			lspconfig.marksman.setup({})
		end,
	},
})

------------------------------------------------------------------------------------------------------------------------
-- Global settings
------------------------------------------------------------------------------------------------------------------------

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.autochdir = true
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noselect"
vim.o.cursorline = true
vim.o.foldenable = false
vim.o.hidden = false
vim.o.incsearch = true
vim.o.list = false
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.smartindent = true
vim.o.spelllang = "en"
vim.o.termguicolors = true
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

if vim.fn.has("unix") == 1 then vim.opt.shell = "bash" end

------------------------------------------------------------------------------------------------------------------------
-- Filetype settings
------------------------------------------------------------------------------------------------------------------------

local filetypeSettingsGroup = vim.api.nvim_create_augroup("FileType settings", { clear = true })

-- JSON
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*.json" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.o.shiftwidth = 2
		vim.o.tabstop = 2
		vim.o.softtabstop = 2
		vim.o.expandtab = true
	end,
})

-- Markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*.md" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.o.textwidth = 140
	end,
})

-- Powershell
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*.ps1" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.o.expandtab = true
		vim.o.shiftwidth = 4
		vim.o.softtabstop = 4
		vim.o.tabstop = 4
		vim.o.textwidth = 140
	end,
})

-- SVG
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*.svg" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.o.expandtab = true
		vim.o.shiftwidth = 2
		vim.o.softtabstop = 2
		vim.o.tabstop = 2
		vim.o.textwidth = 140
	end,
})

-- TeX
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*.tex" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.o.expandtab = true
		vim.o.shiftwidth = 2
		vim.o.softtabstop = 2
		vim.o.tabstop = 2
		vim.o.textwidth = 140
	end,
})

-- Direnv

vim.cmd([[autocmd BufNewFile,BufRead .envrc set filetype=sh]])
vim.cmd([[autocmd BufNewFile,BufRead direnvrc set filetype=bash]])

------------------------------------------------------------------------------------------------------------------------
-- Tweaks
------------------------------------------------------------------------------------------------------------------------

-- Don't replace my clipboard when <Del>
vim.api.nvim_set_keymap("n", "<Del>", '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Del>", '"_x', { noremap = true, silent = true })

-- Following lines in section are from Fatih: https://github.com/fatih/dotfiles

-- Run gofmt/gofmpt, import packages automatically on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("setGoFormatting", { clear = true }),
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
		for _, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
				else
					vim.lsp.buf.execute_command(r.command)
				end
			end
		end

		vim.lsp.buf.format()
	end
})

-- Don't jump forward if I higlight and search for a word
local function stay_star()
	local sview = vim.fn.winsaveview()
	local args = string.format("keepjumps keeppatterns execute %q", "sil normal! *")
	vim.api.nvim_command(args)
	vim.fn.winrestview(sview) ---@diagnostic disable-line
end
vim.keymap.set("n", "*", stay_star, { noremap = true, silent = true })

-- If I visually select words and paste from clipboard, don't replace my
-- clipboard with the selected word, instead keep my old word in the
-- clipboard
vim.keymap.set("x", "p", "\"_dP")

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

if vim.env.TMUX then
	-- Why "sleep 10ms"?  Workaround for neovim/neovim#21856
	vim.cmd([[
		autocmd BufReadPost,FileReadPost,BufNewFile,FocusGained * call system("tmux rename-window '" . expand("%:t") . "'")
		autocmd VimLeave,FocusLost * call system("tmux setw automatic-rename") | sleep 10m
	]])
end

------------------------------------------------------------------------------------------------------------------------
-- Commands
------------------------------------------------------------------------------------------------------------------------

vim.cmd([[autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = true}]])
vim.cmd([[command! -nargs=0 WS %s/\s\+$//gce]])

------------------------------------------------------------------------------------------------------------------------
-- Keymaps
------------------------------------------------------------------------------------------------------------------------

-- <F1>: Diagnostics / No Diagnostics
vim.keymap.set({ "n", "x" }, "<F1>", function() require("toggle_lsp_diagnostics").toggle_diagnostics() end, { silent = true })

-- <F2>: Troubles / No Troubles
vim.keymap.set({ "n", "x" }, "<F2>", function() require("trouble").toggle() end)

-- <F5>:  Format
-- <F6>:  Action
-- <F7>:  Rename
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(event)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = event.buf }

		vim.keymap.set({ "n", "x" }, "<F5>", vim.lsp.buf.format, opts)
		vim.keymap.set({ "n", "v" }, "<F6>", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<F7>", vim.lsp.buf.rename, opts)
	end,
})

-- <">: Switch Window
vim.keymap.set("", '"', "<C-W>w")

-- <M-s/S>: Update/Write All
vim.keymap.set({ "n", "x" }, "<M-s>", ":update<CR>")
vim.keymap.set( "i", "<M-s>", "<C-O>:update<CR>")
vim.keymap.set({ "n", "x" }, "<M-S>", ":wall<CR>")
vim.keymap.set("i", "<M-S>", "<C-O>:wall<CR>")

-- <M-q/Q>: Quit/Quit All
vim.keymap.set({ "n", "x" }, "<M-q>", ":q<CR>", { silent = true })
vim.keymap.set("i", "<M-q>", "<C-O>:q<CR>", { silent = true })
vim.keymap.set({ "n", "x" }, "<M-Q>", ":q!<CR>", { silent = true })

-- <Y>: Yank to end
vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true, silent = true })

-- <CR>: Disable search highlight with a simple key
vim.api.nvim_set_keymap("n", "<CR>", ":noh<CR>", { noremap = true, nowait = true, silent = true })

-- <ı>: Toggle Split

local splitted_window = nil

local function toggle_split(is_vertical)
	if splitted_window then
		vim.api.nvim_win_close(splitted_window, false)
		splitted_window = nil
	else
		if is_vertical then vim.cmd([[vsplit]]) else vim.cmd([[split]]) end
		splitted_window = vim.fn.win_getid()
	end
end

vim.keymap.set("", "ı", function() toggle_split(false) end)

-- <~>: uniq sort
vim.keymap.set("v", "~", ":sort u<cr>")

-- <ö>: Jump to previous diagnostic
vim.keymap.set({ "n", "x" }, "ö", function() vim.diagnostic.goto_prev() end)

-- <ç>: Jump to next diagnostic
vim.keymap.set({ "n", "x" }, "ç", function() vim.diagnostic.goto_next() end)
