return function()
	require("conform").setup({
		optional = true,
		opts = {
			formatters_by_ft = {
				php = { { "pint", "php_cs_fixer" } },
			},
		},
	})
end
