return {
  -- biblioteca requerida
  -- { 'kevinhwang91/promise-async', lazy = true },

  -- el plugin principal
  {
    'kevinhwang91/nvim-ufo',
    -- dependencies = {
    --   'kevinhwang91/promise-async',
    -- },
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufReadPost', -- cargar tras leer un buffer
    keys = {
      -- atajos rápidos (opcionales)
      {
        'zR',
        function()
          require('ufo').openAllFolds()
        end,
        desc = 'Open all folds',
      },
      {
        'zM',
        function()
          require('ufo').closeAllFolds()
        end,
        desc = 'Close all folds',
      },
      {
        'zr',
        function()
          require('ufo').openFoldsExceptKinds()
        end,
        desc = 'Open folds except comment/imports',
      },
    },
    config = function()
      require('ufo').setup {
        -- solo DOS proveedores
        provider_selector = function(bufnr, filetype, buftype)
          -- return { 'indent' } -- single → sin fallback, sin excepción
          return { 'treesitter', 'indent' }
        end,
        preview = {
          win_config = { border = { '', '─', '', '', '', '─', '', '' }, winblend = 0 },
        },
      }

      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },
}
