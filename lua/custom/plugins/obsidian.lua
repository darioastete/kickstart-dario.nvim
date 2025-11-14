return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = false,
    -- ft = 'markdown',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      workspaces = {
        {
          name = 'personal',
          path = '~/Documents/obsidian/personal',
        },
      },
      templates = {
        folder = 'Templates', -- or "Templates" if you use that
        -- optional:
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
      },
      completion = {
        min_chars = 2,
      },
      note_id_func = function(title)
        if title ~= nil then
          return title
            :gsub(' ', '-')
            :gsub('[^A-Za-z0-9%-]', '') -- remueve caracteres raros
            :lower()
        else
          return tostring(os.time())
        end
      end,
      defaults = {
        title = function(note)
          return note.title or note.id
        end,
      },
    },
    config = function(_, opts)
      require('obsidian').setup(opts)
      -- Aquí van tus mappings manualmente
      -- vim.keymap.set('n', '<leader>os', function()
      --   local query = vim.fn.input '🔍 Obsidian Search: '
      --   if query == '' then
      --     return
      --   end
      --
      --   -- Usa el comando directamente
      --   vim.cmd('ObsidianSearch ' .. vim.fn.escape(query, ' '))
      -- end, { desc = 'ObsidianSearch from anywhere (global)' })
      vim.keymap.set('n', '<leader>os', function()
        require('fzf-lua').live_grep {
          prompt = 'Obsidian › ',
          cwd = vim.fn.expand '~/Documents/obsidian/personal',
          rg_opts = '--column --line-number --no-heading --color=always --smart-case -t md',
          winopts = {
            preview = {
              layout = 'vertical',
              vertical = 'up:60%',
            },
          },
        }
      end, { desc = 'Live grep inside Obsidian notes' })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          local map = vim.keymap.set
          local base_opts = { buffer = true }

          map(
            'n',
            '<leader>of',
            require('obsidian').util.gf_passthrough,
            vim.tbl_extend('force', base_opts, {
              noremap = false,
              expr = true,
              desc = 'Obsidian Follow Link',
            })
          )

          map(
            'n',
            '<leader>od',
            require('obsidian').util.toggle_checkbox,
            vim.tbl_extend('force', base_opts, {
              desc = 'Obsidian Toggle Checkbox',
            })
          )

          map(
            'n',
            '<leader>onn',
            function()
              local title = vim.fn.input '📝 Note name: '
              if title == '' then
                return
              end
              vim.cmd('ObsidianNew ' .. title)
            end,
            vim.tbl_extend('force', base_opts, {
              desc = 'Obsidian Nueva Nota',
            })
          )

          map(
            'n',
            '<leader>ont',
            function()
              local title = vim.fn.input '📝 Note name: '
              if title == '' then
                return
              end
              vim.cmd('ObsidianNewFromTemplate ' .. title)
            end,
            vim.tbl_extend('force', base_opts, {
              desc = 'Obsidian Insertar Template',
            })
          )
        end,
      })
    end,
  },

  {
    'ixru/nvim-markdown',
    ft = 'markdown',
    init = function()
      vim.g.vim_markdown_folding_disabled = 1 -- desactiva folding si no te gusta
      vim.g.vim_markdown_conceal = 1 -- activa símbolos bonitos
      vim.g.vim_markdown_frontmatter = 1 -- soporta YAML frontmatter
      vim.g.vim_markdown_math = 1 -- soporta $math$
    end,
  },
}
