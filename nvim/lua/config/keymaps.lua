-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-f>", function()
  local filename = vim.fn.expand("%:p")
  vim.cmd("!google-java-format -i " .. filename .. " && edit " .. filename)
end, { desc = "Format buffer with google-java-format" })

