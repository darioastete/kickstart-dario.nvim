-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  {
    'echasnovski/mini.comment',
    version = '*',
    config = function()
      local comment = require 'mini.comment'
      comment.setup()

      -- Keymaps para comentar
      vim.keymap.set('n', '<leader>/', function()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        comment.toggle_lines(line, line)
      end, { desc = 'Comment current line' })

      vim.keymap.set('v', '<leader>/', function()
        local start_line = vim.fn.line 'v'
        local end_line = vim.fn.line '.'
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
        comment.toggle_lines(start_line, end_line)
      end, { desc = 'Comment selection' })
    end,
  },
}
