-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local gdscript_group = vim.api.nvim_create_augroup("gdscript_indent", { clear = true })

local js_group = vim.api.nvim_create_augroup("js_indent", { clear = true })

-- JS/TS projects conventionally use 2-space indentation. The global
-- shiftwidth=4 (set in options.lua) gets passed to the TypeScript LSP on
-- format, which otherwise rewrites the whole file with 4-space indents.
vim.api.nvim_create_autocmd("FileType", {
  group = js_group,
  pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact", "jsx", "tsx", "json", "jsonc", "css", "scss", "html", "yaml", "vue", "svelte" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = gdscript_group,
  pattern = "gdscript",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = gdscript_group,
  pattern = "*.gd",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd("silent! retab!")
    vim.fn.winrestview(view)
  end,
})
