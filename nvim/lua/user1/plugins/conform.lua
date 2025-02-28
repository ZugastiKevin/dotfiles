local conform = {}

conform["stevearc/conform.nvim"] = {
	lazy = true,
	config = require("configs.formatters.conform"),
}

return conform
