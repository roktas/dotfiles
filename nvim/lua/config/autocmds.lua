local filetypeSettingsGroup = vim.api.nvim_create_augroup("FileType settings", { clear = true })

-- Direnv
vim.cmd([[autocmd BufNewFile,BufRead .envrc set filetype=sh]])
vim.cmd([[autocmd BufNewFile,BufRead direnvrc set filetype=bash]])

-- gitcommit
vim.g.gitcommit_summary_length = 72

-- JSON
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
	end,
})

-- Lua
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.bo.expandtab = false
		vim.bo.shiftwidth = 4
		vim.bo.tabstop = 4
		vim.bo.softtabstop = 4
	end,
})

-- Markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.o.spell = false
		vim.bo.textwidth = 120
		vim.o.formatlistpat = "^s*(d+[]:.)}\t ]-)s*"
	end,
})

-- Powershell
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "ps1" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
		vim.bo.tabstop = 4
	end,
})

-- Ruby
vim.cmd([[autocmd FileType ruby setlocal indentkeys-=.]])

-- Shell
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "sh" },
	callback = function()
		vim.b.autoformat = false
	end,
})

-- SVG
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "svg" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
	end,
})

-- TeX
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "context", "latex", "tex" },
	group = filetypeSettingsGroup,
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
	end,
})

-- Tmux
if vim.env.TMUX then
	-- Why "sleep 10ms"?  Workaround for neovim/neovim#21856
	vim.cmd([[
		autocmd BufReadPost,FileReadPost,BufNewFile,FocusGained * call system("tmux rename-window '" . expand("%:t") . "'")
		autocmd VimLeave,FocusLost * call system("tmux setw automatic-rename") | sleep 10m
	]])
end
