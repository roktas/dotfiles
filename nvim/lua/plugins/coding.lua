return {
	-----------------------------------------------------------------------------------------------------------------------
	-- codeium
	-----------------------------------------------------------------------------------------------------------------------

	{
		"nvim-cmp",
		dependencies = {
			-- neocodeium
			{
				"monkoose/neocodeium",
				event = "VeryLazy",
				cmd = "Neocodeium",
				build = ":Neocodeium Auth",
				opts = {},
				config = function()
					local neocodeium = require("neocodeium")

					neocodeium.setup({ silent = true })

					vim.keymap.set("i", "<A-f>", function()
						neocodeium.accept()
					end)
					vim.keymap.set("i", "<A-w>", function()
						neocodeium.accept_word()
					end)
					vim.keymap.set("i", "<A-a>", function()
						neocodeium.accept_line()
					end)
					vim.keymap.set("i", "<A-e>", function()
						neocodeium.cycle_or_complete()
					end)
					vim.keymap.set("i", "<A-r>", function()
						neocodeium.cycle_or_complete(-1)
					end)
					vim.keymap.set("i", "<A-c>", function()
						neocodeium.clear()
					end)
				end,
			},
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			table.insert(opts.sources, 1, {
				name = "codeium",
				group_index = 1,
				priority = 100,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		optional = true,
		event = "VeryLazy",
		opts = function(_, opts)
			-- luacheck: push ignore 113
			table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("neocodeium"))
			-- luacheck: pop
		end,
	},

	-----------------------------------------------------------------------------------------------------------------------
	-- copilot-chat
	-----------------------------------------------------------------------------------------------------------------------

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken",
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
			prompts = {
				Tests = {
					prompt = "/COPILOT_GENERATE Please generate tests for my code. (Prefer Minitest for Ruby codes)",
				},
			},
		},
	},
}
