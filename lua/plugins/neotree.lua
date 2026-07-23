local function load_project_or_open(state)
  local node = state.tree:get_node()
  local fs_commands = require "neo-tree.sources.filesystem.commands"
  if not node or node.type ~= "directory" then return fs_commands.open(state) end

  local project = require "project_root"
  if project.is_root(state.path) then return fs_commands.open(state) end

  local root = project.root_of(node:get_id())
  if not root then return fs_commands.open(state) end

  require("neo-tree.sources.filesystem")._navigate_internal(state, root, nil, nil, false)
end

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
      commands = { load_project_or_open = load_project_or_open },
      window = {
        mappings = {
          ["<cr>"] = "load_project_or_open",
          ["<2-LeftMouse>"] = "load_project_or_open",
        },
      },
      bind_to_cwd = true,
      cwd_target = { sidebar = "global", current = "global" },
      group_empty_dirs = false,
      scan_mode = "shallow",
      follow_current_file = { enabled = false },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = { ".DS_Store", ".vsconfig" },
        hide_by_name = { "target", ".git", "node_modules", ".direnv" },
        never_show_by_pattern = { "*.meta", "*.asset", "*.csproj", "*.csproj.user", "*.sln" },
      },
    },
  },
}
