local function bubble_format(symbol)
  local fragments = {}
  local content = {}

  if symbol.references then
    local label = symbol.references == 1 and "ref" or "refs"
    content[#content + 1] = symbol.references .. " " .. label
  end
  if symbol.definition then
    content[#content + 1] = symbol.definition .. " def"
  end
  if symbol.implementation then
    content[#content + 1] = symbol.implementation .. " impl"
  end
  if #content == 0 then return {} end

  fragments[#fragments + 1] = { "", "GirlyBubbleEdge" }
  fragments[#fragments + 1] = { table.concat(content, " · "), "GirlyBubbleContent" }
  fragments[#fragments + 1] = { " ", "GirlyBubbleEdge" }
  return fragments
end

---@type LazySpec
return {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach",
  opts = {
    vt_position = "above",
    text_format = bubble_format,
    disable = { filetypes = { "purr", "hytaleui" } },
  },
}
