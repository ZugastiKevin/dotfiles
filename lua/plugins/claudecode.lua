---@type LazySpec
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.35,
      provider = "snacks",
    },
  },
  keys = {
    { "<Leader>a", nil, desc = "IA (Claude Code)" },
    { "<Leader>ac", "<Cmd>ClaudeCode<CR>", desc = "Toggle Claude Code" },
    { "<Leader>af", "<Cmd>ClaudeCodeFocus<CR>", desc = "Focus le panneau" },
    { "<Leader>ar", "<Cmd>ClaudeCode --resume<CR>", desc = "Reprendre une session" },
    { "<Leader>aC", "<Cmd>ClaudeCode --continue<CR>", desc = "Continuer la derniere session" },
    { "<Leader>am", "<Cmd>ClaudeCodeSelectModel<CR>", desc = "Choisir le modele" },
    { "<Leader>ab", "<Cmd>ClaudeCodeAdd %<CR>", desc = "Ajouter le buffer courant" },
    { "<Leader>as", "<Cmd>ClaudeCodeSend<CR>", mode = "v", desc = "Envoyer la selection" },
    {
      "<Leader>as",
      "<Cmd>ClaudeCodeTreeAdd<CR>",
      desc = "Ajouter le fichier",
      ft = { "neo-tree", "neotree" },
    },
    { "<Leader>aa", "<Cmd>ClaudeCodeDiffAccept<CR>", desc = "Accepter le diff" },
    { "<Leader>ax", "<Cmd>ClaudeCodeDiffDeny<CR>", desc = "Refuser le diff" },
    { "<D-i>", "<Cmd>ClaudeCode<CR>", mode = { "n", "v", "t" }, desc = "Toggle Claude Code" },
  },
}
