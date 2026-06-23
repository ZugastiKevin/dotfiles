---@type LazySpec
return {
  "b0o/incline.nvim",
  event = "VeryLazy",
  opts = {
    window = {
      margin = { vertical = 0, horizontal = 1 },
      padding = 1,
      placement = { horizontal = "right", vertical = "top" },
    },
    hide = { cursorline = true },
    render = function(props)
      local name = vim.api.nvim_buf_get_name(props.buf)
      local fname = vim.fn.fnamemodify(name, ":t")
      if fname == "" then fname = "[No Name]" end
      local modified = vim.bo[props.buf].modified
      local accent = props.focused and "#ff4fd8" or "#9a8aa8"
      local segments = {}
      local ok, devicons = pcall(require, "nvim-web-devicons")
      if ok then
        local icon, color = devicons.get_icon_color(fname, nil, { default = true })
        if icon then table.insert(segments, { icon .. " ", guifg = color }) end
      end
      table.insert(segments, { fname, guifg = accent, gui = modified and "bold,italic" or "bold" })
      if modified then table.insert(segments, { " ●", guifg = "#ff6ac1" }) end
      return segments
    end,
  },
}
