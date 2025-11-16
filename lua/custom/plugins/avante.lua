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
        name = 'commit_obsidian',
        description = 'Generate commit message for Obsidian plugin',
        details = 'Generate a conventional commit message in Spanish analyzing git diff for an Obsidian plugin',
        prompt = [[
          I want you to generate a commit message following this format:
          type: YYYY-MM-DD — short description
          Where:
          type can be one of the following: notes, journal, ideas, tasks, research, refactor, cleanup, archive.
          YYYY-MM-DD is the current date.
          short description is a very brief summary of what I did in my notes.
          Context: These are my notes for today:
          $text
          Generate only the commit message, professional, clear, and concise.
          Do not add explanations — only the final commit.
        ]],
      },
      {
        name = 'commit_309',
        description = 'Generate commit message',
        details = 'Generate a conventional commit message in Spanish analyzing git diff',
        prompt = [[
          You are a Git/GitHub expert. From the given diff (and optional user hints), produce:
          1) a Conventional Commit message, and
          2) a Pull Request (PR) title and description.

          ## GLOBAL RULES
          - Input is a unified diff. If the user provides extra hints (type, scope, description, JIRA-ID), respect them.
          - If the user provides a **type**, use it exactly. If not, infer it from the diff.
          - If the user provides a **scope**, use it. Otherwise infer it from changed paths (e.g., "auth", "ui", "api", "build").
          - If the user provides a **description**, complement it with the diff context (do not ignore the diff).

          ## COMMIT MESSAGE (Conventional Commits)
          - **Format:** <type>: <JIRA-IDs> <description>
            - Example (single): `fix: HVACAI-120 update login validation logic`
            - Example (multiple): `fix: HVACAI-112 HVACAI-113 update sidebar rendering logic and branding`
          - **Allowed types:** feat, fix, docs, style, refactor, test, chore, perf
          - **Verbs:** infinitive, lowercase (e.g., "add", "fix", "refactor").
          - **Single line only (no body nor footer).**
          - **≤ 50 chars** total; if longer, rewrite to fit while keeping clarity.
          - **Breaking changes:** if clearly present, add `!` after the scope, e.g., `feat(api)!: ...`
          - Do **not** include JIRA IDs here **unless the user explicitly provided one to include**.

          ## PULL REQUEST
          - **Title structure (mandatory):** `[type]: [JIRA-ID] Short and clear description`
            - Example: `fix: HVACAI-120 Add frontend form for password reset`
            - If multiple tickets apply, separate with spaces: `fix: HVACAI-112 HVACAI-113 ...`
            - Max ~80 chars; if longer, condense while staying clear.
          - **Description (Markdown) sections:**
            - `### Summary` – brief what/why.
            - `### Changes Introduced` – bullet points of key changes.
            - `### Testing Steps` – numbered steps to verify.
            - `### Visual Evidence` – optional link(s)/screenshot(s) if UI changes.
          - Professional and objective tone.
          - Infer content from the diff; mention impacted modules/components.
          - If the user supplied a short description, **merge** it with your analysis (do not duplicate).

          ## INPUT
          Diff (and optional hints):
          $text

          ## OUTPUT
          Return **only** the following, nothing else:

          Commit message:
          <one line conventional commit>

          PR title:
          <type>: <JIRA-ID> <short description>

          PR description:
          ### Summary
          ...
          ### Changes Introduced
          - ...
          ### Testing Steps
          1. ...
          ### Visual Evidence
          (optional links)
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
