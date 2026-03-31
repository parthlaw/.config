-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-f>", function()
  local filename = vim.fn.expand("%:p")
  vim.cmd("!google-java-format -i " .. filename .. " && edit " .. filename)
end, { desc = "Format buffer with google-java-format" })
vim.keymap.set("n", "<leader>e", function()
  local cwd = vim.loop.cwd()
  local git_root = require("snacks.git").get_root(cwd)

  local root = cwd
  if git_root and cwd:find(git_root, 1, true) == 1 then
    root = git_root
  end

  require("snacks").picker.explorer({
    root = root,
  })
end)
