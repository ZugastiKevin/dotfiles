---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = false,
    enable_git_status = true,
    enable_diagnostics = true,
    window = {
      position = "left",
      width = 34,
    },
    default_component_configs = {
      indent = { with_expanders = true, expander_collapsed = "", expander_expanded = "" },
      git_status = {
        symbols = {
          added = "✚",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    },
    filesystem = {
      bind_to_cwd = true,
      cwd_target = { sidebar = "global", current = "global" },
      group_empty_dirs = true,
      scan_mode = "deep",
      follow_current_file = { enabled = false },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = { ".DS_Store", ".vsconfig" },
        never_show_by_pattern = { "*.meta", "*.asset", "*.csproj", "*.csproj.user", "*.sln" },
      },
    },
  },
}
