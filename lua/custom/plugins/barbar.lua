return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    version = '^1.0.0',
    opts = {
      animation = true,
      auto_hide = false,
      tabpages = true,
      clickable = true,
      sidebar_filetypes = {
        NvimTree = true,
        ['neo-tree'] = { event = 'BufWipeout' },
        undotree = { text = 'undotree' },
      },
    },
  },
}
