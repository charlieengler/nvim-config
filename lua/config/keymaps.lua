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

local function has_minic()
  local ok, m = pcall(require, "mini.comment")
  return ok and m
end

local function comment_lines(from, to)
  if has_minic() then
    -- mini.comment API: toggle_lines(from, to)
    require("mini.comment").toggle_lines(from, to)
  else
    -- fallback to Comment.nvim API (linewise)
    -- visualmode arg is ignored by toggle.linewise when range provided,
    -- so we call toggle.linewise with the current visualmode for compatibility.
    require("Comment.api").toggle.linewise(vim.fn.visualmode() or "v")
  end
end

-- VISUAL: works for char / line / block visual (keeps style you requested)
vim.keymap.set({ "x" }, "<C-_>", function()
  local from = vim.fn.line("v")
  local to = vim.fn.line(".")
  if from > to then
    from, to = to, from
  end
  comment_lines(from, to)
end, { desc = "Toggle comment (visual)" })
vim.keymap.set({ "x" }, "<C-/>", function()
  local from = vim.fn.line("v")
  local to = vim.fn.line(".")
  if from > to then
    from, to = to, from
  end
  comment_lines(from, to)
end, { desc = "Toggle comment (visual)" })

-- NORMAL: toggle current line
vim.keymap.set("n", "<C-_>", function()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  comment_lines(row, row)
end, { desc = "Toggle comment (line)" })
vim.keymap.set("n", "<C-/>", function()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  comment_lines(row, row)
end, { desc = "Toggle comment (line)" })

-- INSERT: escape, toggle current line, restore cursor, return to insert
vim.keymap.set("i", "<C-_>", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- leave insert
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  -- comment current line
  comment_lines(row, row)
  -- restore cursor (safe pcall) and re-enter insert
  pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), "n", false)
end, { desc = "Toggle comment (insert)" })
vim.keymap.set("i", "<C-/>", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  comment_lines(row, row)
  pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), "n", false)
end, { desc = "Toggle comment (insert)" })
