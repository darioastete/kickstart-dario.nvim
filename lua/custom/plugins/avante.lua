return {
  'yetone/avante.nvim',
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = function()
    -- conditionally use the correct build system for the current OS
    if vim.fn.has 'win32' == 1 then
      return 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
    else
      return 'make BUILD_FROM_SOURCE=true'
    end
  end,
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- for example
    -- provider = 'copilot',
    provider = 'moonshot',
    providers = {
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-5-nano', -- o 'gpt-4-turbo', 'gpt-3.5-turbo', etc.
        timeout = 30000,
        -- extra_request_body = {
        --   temperature = 0.7,
        --   max_tokens = 2048,
        -- },
      },
      moonshot = {
        endpoint = 'https://api.moonshot.ai/v1',
        -- model = 'kimi-k2-0711-preview',
        model = 'kimi-k2-turbo-preview',
        timeout = 30000,
        extra_request_body = {
          temperature = 0.6,
          max_tokens = 32768,
        },
      },
      -- claude = {
      --   endpoint = 'https://api.anthropic.com',
      --   model = 'claude-sonnet-4-20250514',
      --   timeout = 30000, -- Timeout in milliseconds
      --   extra_request_body = {
      --     temperature = 0.75,
      --     max_tokens = 20480,
      --   },
      -- },
    },
    behaviour = {
      auto_suggestions = false,
      auto_approve_tool_permissions = false,
      confirmation_ui_style = 'inline_buttons',
    },
    -- system_prompt as function ensures LLM always has latest MCP server state
    -- This is evaluated for every message, even in existing chats
    -- system_prompt = function()
    --   local hub = require('mcphub').get_hub_instance()
    --   return hub and hub:get_active_servers_prompt() or ''
    -- end,
    -- -- Using function prevents requiring mcphub before it's loaded
    -- custom_tools = function()
    --   return {
    --     require('mcphub.extensions.avante').mcp_tool(),
    --   }
    -- end,
    shortcuts = {
      {
        name = 'commit_309',
        description = 'Generate commit message',
        details = 'Generate a conventional commit message in Spanish analyzing git diff',
        prompt = [[
          You are a Git and GitHub expert. Analyze the following code diff and generate both:
          1. A concise and conventional **commit message**.
          2. A **Pull Request title and description**.

          ---

          ### COMMIT MESSAGE RULES
          - **Format:** <type>(<scope>): <description>
          - **Allowed types:** feat, fix, docs, style, refactor, test, chore, perf
          - **If the user provides a type, use it exactly as given.**
          - **If no type is provided, infer the most appropriate one from the diff.**
          - **Use infinitive verbs in lowercase** (e.g., "add", "fix", "refactor").
          - **Do not include a body or footer.**
          - **The first line must not exceed 50 characters.**
          - **Follow the Conventional Commits standard strictly.**
          - **If the description exceeds 50 characters, rephrase it to fit while keeping clarity.**

          ---

          ### PULL REQUEST RULES
          - The **title** should be clear and concise (max 80 characters), ideally expanding on the commit message.
          - The **description** should summarize:
            - What was changed.
            - Why it was changed.
            - How it impacts the system (optional).
          - Keep the tone **professional and objective**.
          - Use Markdown formatting when relevant (e.g., bullet points, short paragraphs).

          ---

          ### INPUT
          Diff or description:
          $text

          ---

          ### OUTPUT
          Return only:
          1. **Commit message:** in the specified format.
          2. **Pull Request title:** short and descriptive.
          3. **Pull Request description:** concise summary in Markdown.

          Do not include any explanations or reasoning in the output.
        ]],
      },
      {
        name = 'refactor_dry_kiss',
        description = 'Refactor code using DRY and KISS principles',
        details = 'Refactor the following code to improve its structure using DRY and KISS principles',
        prompt = [[
          Refactoriza el siguiente código para mejorar su estructura usando los principios DRY (Don't Repeat Yourself) y KISS (Keep It Simple, Stupid).
          Asegúrate de que el código resultante sea más limpio, eficiente y fácil de mantener, sin cambiar su funcionalidad original.
          Código:
          $text
          Código refactorizado:
        ]],
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    -- 'echasnovski/mini.pick', -- for file_selector provider mini.pick
    -- 'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    -- 'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'stevearc/dressing.nvim', -- for input provider dressing
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
  -- config = function(_, opts)
  --   require('avante').setup {
  --     opts,
  --     disabled_tools = {
  --       'list_files', -- Built-in file operations
  --       'search_files',
  --       'read_file',
  --       'create_file',
  --       'rename_file',
  --       'delete_file',
  --       'create_dir',
  --       'rename_dir',
  --       'delete_dir',
  --       'bash', -- Built-in terminal access
  --     },
  --   }
  -- end,
}
