local M = {}

local function declares_workspace(manifest)
  for line in io.lines(manifest) do
    if line:match "^%s*%[workspace[%.%]]" then return true end
  end
  return false
end

function M.workspace_root(fname)
  if not fname or fname == "" then return nil end
  local manifests = vim.fs.find("Cargo.toml", { upward = true, path = vim.fs.dirname(fname), limit = math.huge })
  if #manifests == 0 then return nil end
  for i = #manifests, 1, -1 do
    local ok, is_workspace = pcall(declares_workspace, manifests[i])
    if ok and is_workspace then return vim.fs.dirname(manifests[i]) end
  end
  return vim.fs.dirname(manifests[1])
end

return M
