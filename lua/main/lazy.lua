local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup({ { import = "main.plugins" }, { import = "main.plugins.lsp" } }, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local file = vim.fn.expand("%")
		vim.fn.jobstart({ "goimports", "-w", file }, {
			on_exit = function(_, exit_code)
				if exit_code == 0 then
					vim.cmd("e!") -- ファイルを再読み込み
				else
					print("goimports failed")
				end
			end,
		})
	end,
})
