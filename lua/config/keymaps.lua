-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

keymap.set("n", ">", ":>")
keymap.set("n", "<", ":<")

keymap.set("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-t>", function()
  require("snacks").terminal.toggle()
end, { desc = "Terminal (toggle)" })

vim.keymap.set({ "x" }, "<C-_>", function()
  local mode = vim.fn.visualmode()
  local from = vim.fn.line("v")
  local to = vim.fn.line(".")
  require("mini.comment").toggle_lines(from, to)
end, { desc = "Comment selection (any visual mode)" })
