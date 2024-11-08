------------------------------------------------------------------------------------------------------------------------
--- Core settings
------------------------------------------------------------------------------------------------------------------------

return {
	-- nord.nvim
	{
		"gbprod/nord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nord").setup({})
			vim.cmd.colorscheme("nord")
		end,
	},

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "nord",
		},
	},
}
