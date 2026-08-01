---@type LazySpec
return {
  "y3owk1n/time-machine.nvim",
  version = "*",
  cmd = { "TimeMachineToggle", "TimeMachineLogShow", "TimeMachinePurgeBuffer", "TimeMachinePurgeAll" },
  opts = {
    split_opts = { split = "left", width = 52 },
    diff_tool = "native",
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>fU"] = { "<Cmd>TimeMachineToggle<CR>", desc = "Time machine (timeline d'undo)" },
          },
        },
      },
    },
  },
}
