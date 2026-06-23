vim.o.background = "dark"
vim.g.colors_name = "girlypop"

local girly = require "girly"
pcall(vim.cmd.colorscheme, girly.base)
vim.g.colors_name = "girlypop"
girly.apply(girly.resolve())
