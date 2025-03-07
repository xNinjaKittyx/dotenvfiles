require'nvim-treesitter.configs'.setup {
  -- list of parser names
  ensured_installed = { "lua", "rust", "vim", "python" },

  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
