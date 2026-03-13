-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add ~/.local/bin to PATH for acp wrapper
vim.env.PATH = vim.fn.expand("~/.local/bin") .. ":" .. vim.env.PATH
