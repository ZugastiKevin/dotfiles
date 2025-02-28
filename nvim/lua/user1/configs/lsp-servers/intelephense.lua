local util = require("lspconfig.util")

return {
	-- PHP
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_dir = function(pattern)
		local cwd = vim.loop.cwd()
		local root = util.root_pattern("composer.json", ".git")(pattern)

		-- prefer cwd if root is a descendant
		return util.path.is_descendant(cwd, root) and cwd or root
	end,
}
