return {
  'windwp/nvim-ts-autotag',
  event = 'VeryLazy',
  config = function()
    require('nvim-ts-autotag').setup {
      -- opts = {
      --   enable = true,
      --   aliases = {
      --     ['typescriptreact'] = 'html',
      --     ['javascriptreact'] = 'html',
      --     ['vue'] = 'html',
      --     ['astro'] = 'html',
      --   },
      -- },
    }
  end,
}
