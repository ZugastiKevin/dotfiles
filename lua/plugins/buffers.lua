local function buf_next() require("astrocore.buffer").nav(vim.v.count1) end
local function buf_prev() require("astrocore.buffer").nav(-vim.v.count1) end
local function buf_close() require("astrocore.buffer").close() end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    mappings = {
      n = {
        ["<D-w>"] = { buf_close, desc = "Fermer le buffer" },
        ["<D-n>"] = { "<Cmd>enew<CR>", desc = "Nouveau fichier" },
        ["<D-S-]>"] = { buf_next, desc = "Buffer suivant" },
        ["<D-}>"] = { buf_next, desc = "Buffer suivant" },
        ["<D-S-[>"] = { buf_prev, desc = "Buffer precedent" },
        ["<D-{>"] = { buf_prev, desc = "Buffer precedent" },
      },
      i = {
        ["<D-w>"] = { function() vim.cmd "stopinsert"; buf_close() end, desc = "Fermer le buffer" },
        ["<D-S-]>"] = { function() vim.cmd "stopinsert"; buf_next() end, desc = "Buffer suivant" },
        ["<D-S-[>"] = { function() vim.cmd "stopinsert"; buf_prev() end, desc = "Buffer precedent" },
      },
    },
  },
}
