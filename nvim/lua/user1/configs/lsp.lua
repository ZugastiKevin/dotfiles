local nvim_lsp = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

return {
	-- PHP
	require(nvim_lsp).intelephense.setup({
		commands = {
			IntelephenseIndex = {
				function()
					vim.lsp.buf.execute_command({ command = "intelephense.index.workspace" })
				end,
			},
		},
		on_attach = function(client, bufnr)
			-- client.server_capabilities.documentFormattingProvider = false
			-- client.server_capabilities.documentRangeFormattingProvider = false
			-- if client.server_capabilities.inlayHintProvider then
			--   vim.lsp.buf.inlay_hint(bufnr, true)
			-- end
		end,
		capabilities = capabilities,
	}),
}
