vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { "rose-pine/neovim", name = "rose-pine" },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}
}
local ops = {}

require("lazy").setup(plugins, opts)
local builtin = require("telescope.builtin")

local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "lua", "vim", "vimdoc", "query", "javascript", "html", "ruby", "bash", "typescript" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})

-- keymaps
vim.g.mapleader = " "
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- theme
require("rose-pine").setup()
vim.cmd.colorscheme "rose-pine"
