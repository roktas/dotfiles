return {
	{
		"direnv/direnv.vim",
	},
	{
		"klen/nvim-config-local",
		opts = { config_files = { ".nvim.lua", ".nvimrc", ".exrc" } },
	},
	{
		"Rawnly/gist.nvim",
		cmd = { "GistCreate", "GistCreateFromFile", "GistsList" },
		config = true,
	},
	{
		"roktas/turkish.nvim",
		config = function()
			require("turkish").defaults()
		end,
		branch = "main",
	},
	{
		"preservim/vim-pencil",

		config = function()
			vim.cmd([[
				augroup pencil
				  autocmd!
				  autocmd FileType markdown,mkd call pencil#init() | PencilOff
				  autocmd FileType text         call pencil#init() | PencilOff
				augroup END
				let g:pencil#textwidth = 120
			]])
		end,
	},
}
