vim.g.mapleader = " "

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins that work in both VS Code and terminal Neovim (editing behavior only)
require("lazy").setup({
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },
  { "echasnovski/mini.ai", version = "*", event = "VeryLazy", opts = {} },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
})

if vim.g.vscode then
  -- VS Code only
  local vscode = require('vscode')
  -- fzf-picker (fzf + ripgrep + bat in the integrated terminal, telescope-style)
  vim.keymap.set('n', '<leader>ff', function() vscode.action('fzf-picker.findFiles') end)
  -- <leader>e toggles the explorer: opens + focuses it, or closes it if already open.
  -- VS Code has no API to query sidebar visibility, so we track it ourselves.
  local explorer_open = false
  vim.keymap.set('n', '<leader>e', function()
    if explorer_open then
      vscode.action('workbench.action.closeSidebar')
    else
      vscode.action('workbench.view.explorer')
    end
    explorer_open = not explorer_open
  end)
  vim.keymap.set('n', '<leader>fg', function() vscode.action('fzf-picker.findWithinFiles') end)
  vim.keymap.set('n', '<leader>fr', function() vscode.action('fzf-picker.resumeSearch') end)
  vim.keymap.set('n', '<leader>fc', function() vscode.action('fzf-picker.pickFileFromGitStatus') end)
  vim.keymap.set('n', '<leader>ft', function() vscode.action('fzf-picker.findTodoFixme') end)
  vim.keymap.set('n', '<leader><leader>', function() vscode.action('workbench.action.quickOpen') end) -- built-in quick open
  vim.keymap.set('n', '<leader>fs', function() vscode.action('workbench.action.gotoSymbol') end)
  vim.keymap.set('n', '<leader>o', function() vscode.action('workbench.action.files.openFolder') end)
  vim.keymap.set('n', '<leader>r', function() vscode.action('workbench.action.openRecent') end)
  -- Editor top padding: 25px by default (room for the macOS traffic lights), 0 in fullscreen.
  local PAD = 25
  local function set_padding(px)
    vscode.eval_async(
      "await vscode.workspace.getConfiguration('editor').update('padding.top', args.px, vscode.ConfigurationTarget.Global)",
      { args = { px = px } })
  end
  -- <leader>F: enter fullscreen and remove padding; press again to leave and restore it.
  -- State is read from the live setting (padding > 0 means windowed), so it survives Neovim restarts.
  vim.keymap.set('n', '<leader>F', function()
    local current = vscode.eval("return vscode.workspace.getConfiguration('editor').get('padding.top')") or 0
    set_padding(current > 0 and 0 or PAD)
    vscode.action('workbench.action.toggleFullScreen')
  end)
  -- Manual fixes if it drifts (e.g. left fullscreen via macOS gesture)
  vim.api.nvim_create_user_command('PadOn',  function() set_padding(PAD) end, {})
  vim.api.nvim_create_user_command('PadOff', function() set_padding(0)   end, {})
else
  -- terminal Neovim only (colorschemes, LSP, statusline)
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.hl.on_yank({ timeout = 150 }) end,
  })
end
