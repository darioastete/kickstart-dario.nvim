# Neovim Configuration - Developer Handover Document

## 📋 Table of Contents

1. [Project Overview](#-project-overview)
2. [Architecture & Structure](#-architecture--structure)
3. [Core Configuration](#-core-configuration)
4. [Plugin Management](#-plugin-management)
5. [LSP Configuration](#-lsp-configuration)
6. [Custom Plugins Documentation](#-custom-plugins-documentation)
7. [Key Mappings Reference](#-key-mappings-reference)
8. [Development Workflow](#-development-workflow)
9. [External Dependencies](#-external-dependencies)
10. [Troubleshooting](#-troubleshooting)

---

## 🎯 Project Overview

### What is This?

This is a **heavily customized Neovim configuration** based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It's designed for modern web development (TypeScript, JavaScript, Vue.js) with AI-assisted coding capabilities.

### Philosophy

- **Single-file base**: Core configuration in `init.lua` (following kickstart.nvim pattern)
- **Modular plugins**: Custom plugins organized in `lua/custom/plugins/`
- **Opinionated setup**: Pre-configured for TypeScript/Vue.js development
- **AI-enhanced**: Integrated Copilot and Avante.nvim for AI assistance

### Key Features

- ✅ LSP support (TypeScript, Vue, Lua, etc.)
- ✅ Advanced fuzzy finding with fzf-lua
- ✅ AI coding assistants (Copilot, Avante)
- ✅ Git integration (Gitsigns, LazyGit)
- ✅ Obsidian note-taking integration
- ✅ Modern UI with barbar.nvim bufferline
- ✅ Smart code folding with nvim-ufo
- ✅ Extensive custom keybindings

---

## 🏗️ Architecture & Structure

### Directory Layout

```
.
├── init.lua                      # Main configuration entry point (1250 lines)
├── lua/
│   ├── kickstart/
│   │   ├── health.lua           # Health check utilities
│   │   └── plugins/             # Kickstart-provided plugins
│   │       ├── autopairs.lua    # Auto-close brackets
│   │       ├── debug.lua        # Debug adapter protocol (not active)
│   │       ├── gitsigns.lua     # Git integration
│   │       ├── indent_line.lua  # Indentation guides
│   │       ├── lint.lua         # Linting with nvim-lint
│   │       └── neo-tree.lua     # File explorer
│   └── custom/
│       └── plugins/             # Custom plugin configurations
│           ├── init.lua         # UI enhancements, comments, etc.
│           ├── avante.lua       # AI assistant integration
│           ├── barbar.lua       # Buffer tabline
│           ├── obsidian.lua     # Note-taking integration
│           ├── ufo.lua          # Advanced folding
│           ├── auto-tag.lua     # HTML/JSX auto-tags
│           ├── nvim-cmp.lua     # Alternative completion (not active)
│           └── mcphub.lua       # MCP server integration (not active)
├── doc/
│   └── kickstart.txt            # Kickstart documentation
├── .stylua.toml                 # Lua formatter configuration
├── .gitignore
├── README.md                    # Original kickstart README
├── LICENSE.md
└── diff.txt                     # Recent changes tracking
```

### File Organization Pattern

- **Single init.lua**: Contains core settings, keymaps, and main plugin setup
- **Modular plugins**: Each custom plugin in separate file under `lua/custom/plugins/`
- **Lazy loading**: Plugins loaded on-demand via lazy.nvim
- **Clear separation**: Kickstart defaults vs custom modifications

---

## ⚙️ Core Configuration

### Essential Settings (`init.lua`)

#### Leader Keys
```lua
vim.g.mapleader = ' '           -- Space as leader key
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false    -- Set to true if using Nerd Font
```

#### Indentation
```lua
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.tabstop = 2             -- 2 spaces per tab
vim.opt.shiftwidth = 2          -- 2 spaces for auto-indent
vim.opt.softtabstop = 2
```

#### Editor Behavior
```lua
vim.o.number = true             -- Line numbers
vim.o.relativenumber = true     -- Relative line numbers
vim.o.mouse = 'a'               -- Mouse support
vim.o.clipboard = 'unnamedplus' -- System clipboard sync
vim.o.undofile = true           -- Persistent undo
vim.o.ignorecase = true         -- Case-insensitive search
vim.o.smartcase = true          -- Unless uppercase in search
vim.o.signcolumn = 'yes'        -- Always show sign column
vim.o.updatetime = 250          -- Faster CursorHold events
vim.o.timeoutlen = 300          -- Faster key sequence timeout
vim.o.splitright = true         -- Vertical splits to right
vim.o.splitbelow = true         -- Horizontal splits below
vim.o.cursorline = true         -- Highlight current line
vim.o.scrolloff = 10            -- Keep 10 lines above/below cursor
vim.o.confirm = true            -- Confirm on unsaved changes
```

#### Folding (Enhanced with nvim-ufo)
```lua
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.o.foldcolumn = '1'
```

### Autocommands

#### Highlight on Yank
```lua
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})
```

---

## 🔌 Plugin Management

### Lazy.nvim Setup

Plugin manager: **[lazy.nvim](https://github.com/folke/lazy.nvim)**

#### Installation Path
```lua
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
```

Auto-installs if not present. Lazy.nvim is bootstrapped automatically on first run.

### Plugin Categories

#### 1. Core Utilities
- **guess-indent.nvim**: Auto-detect indentation
- **which-key.nvim**: Keymap helper
- **gitsigns.nvim**: Git decorations

#### 2. LSP & Completion
- **nvim-lspconfig**: LSP configuration
- **mason.nvim**: LSP/tool installer
- **mason-lspconfig.nvim**: Mason-LSP bridge
- **mason-tool-installer.nvim**: Auto-install tools
- **blink.cmp**: Completion engine (modern alternative to nvim-cmp)
- **LuaSnip**: Snippet engine

#### 3. Code Intelligence
- **nvim-treesitter**: Syntax parsing
- **conform.nvim**: Auto-formatting
- **nvim-lint**: Linting

#### 4. Fuzzy Finding
- **fzf-lua**: Fast fuzzy finder (replaces Telescope)

#### 5. AI Assistants
- **copilot.lua**: GitHub Copilot integration
- **avante.nvim**: Multi-provider AI chat (supports Moonshot/OpenAI)

#### 6. UI Enhancements
- **barbar.nvim**: Buffer tabs
- **neo-tree.nvim**: File explorer
- **mini.nvim**: Collection of mini modules (statusline, ai, surround)
- **noice.nvim**: Better UI for messages/cmdline
- **nvim-notify**: Notification system
- **smear-cursor.nvim**: Smooth cursor animation
- **indent-blankline.nvim**: Indentation guides

#### 7. File Types
- **obsidian.nvim**: Obsidian note integration
- **nvim-markdown**: Enhanced markdown support
- **render-markdown.nvim**: Markdown rendering

#### 8. Editor Enhancements
- **nvim-autopairs**: Auto-close pairs
- **nvim-ts-autotag**: Auto-close HTML/JSX tags
- **Comment.nvim**: Smart commenting with context
- **better-escape.nvim**: `jj` to escape insert mode
- **multiple-cursors.nvim**: VSCode-like multi-cursor
- **precognition.nvim**: Motion hints
- **neoscroll.nvim**: Smooth scrolling
- **toggleterm.nvim**: Terminal integration
- **nvim-ufo**: Advanced code folding

#### 9. Color Scheme
- **bluloco.nvim**: Active theme (light/dark variants)
- Others commented out: tokyonight, yorumi, citruszest, nordic

---

## 🔧 LSP Configuration

### Installed Language Servers

Configured via Mason in `init.lua`:

```lua
local servers = {
  lua_ls = {},     -- Lua
  vtsls = {},      -- TypeScript/JavaScript (successor to tsserver)
  vue_ls = {},     -- Vue.js
}
```

### Vue.js + TypeScript Integration

Special configuration for Vue + TS hybrid projects:

```lua
local vue_language_server_path = vim.fn.stdpath('data')
  .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
}

local vtsls_config = {
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = { vue_plugin },
      },
    },
  },
}
```

### LSP Keymaps (Auto-set on LSP Attach)

| Keymap | Action | Description |
|--------|--------|-------------|
| `gd` | Go to definition | Jump to where symbol is defined |
| `grn` | Rename | Rename symbol across files |
| `gra` | Code action | Show available code actions |
| `grr` | References | Find all references (fzf-lua) |
| `gri` | Implementations | Find implementations (fzf-lua) |
| `grD` | Declaration | Go to declaration |
| `<leader>th` | Toggle inlay hints | Show/hide type hints |

### Diagnostic Configuration

```lua
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = {
    source = 'if_many',
    spacing = 2,
  },
  signs = {
    [ERROR] = '󰅚 ',
    [WARN] = '󰀪 ',
    [INFO] = '󰋽 ',
    [HINT] = '󰌶 ',
  },
}
```

### Formatters

Configured via conform.nvim:

```lua
formatters_by_ft = {
  lua = { 'stylua' },
  javascript = { 'prettierd' },
  typescript = { 'prettierd' },
  vue = { 'prettierd' },
  -- ... more file types
}
```

Auto-formats on save (except for C/C++).

### Mason Tools

Auto-installed tools:
- `stylua` (Lua formatter)
- `vue_ls` (Vue Language Server)
- `vtsls` (TypeScript Language Server)

Run `:Mason` to manage tools manually.

---

## 📦 Custom Plugins Documentation

### 1. **avante.nvim** - AI Assistant

**Purpose**: Multi-provider AI chat interface for coding assistance

**File**: `lua/custom/plugins/avante.lua`

**Configuration**:
- Primary provider: `moonshot` (Kimi AI)
- Alternative: `openai` (commented out)
- Model: `kimi-k2-turbo-preview`
- Temperature: 0.6
- Max tokens: 32768

**Custom Shortcuts**:

#### `commit_309`
Generates conventional commit messages in Spanish from git diff.

Format: `<type>(<scope>): <description>`

Types: feat, fix, docs, style, refactor, test, chore, perf

#### `refactor_dry_kiss`
Refactors code using DRY and KISS principles while maintaining functionality.

**Dependencies**:
- fzf-lua (file selector)
- dressing.nvim (input provider)
- snacks.nvim (input provider)
- render-markdown.nvim (markdown rendering)
- img-clip.nvim (image pasting in chat)
- copilot.lua (provider integration)

**Keymaps**:
Check `:h avante` for default keymaps in Avante chat window.

---

### 2. **copilot.lua** - GitHub Copilot

**Purpose**: VSCode-like inline AI suggestions

**File**: Configured in `init.lua` (lines ~720-750)

**Configuration**:
```lua
{
  suggestion = {
    enabled = true,
    auto_trigger = true,        -- Automatic suggestions
    debounce = 75,
  },
  panel = { enabled = false },  -- No sidebar panel
}
```

**Keymaps**:
| Keymap | Action |
|--------|--------|
| `<C-l>` | Accept suggestion |
| `<M-]>` | Next suggestion (⌥ + ]) |
| `<M-[>` | Previous suggestion (⌥ + [) |
| `<C-h>` | Dismiss suggestion |

**Enabled for**: markdown, sh, lua, python, js, ts, vue, astro, and all files

---

### 3. **barbar.nvim** - Buffer Tabs

**Purpose**: VSCode-like buffer tabs at the top

**File**: `lua/custom/plugins/barbar.lua`

**Keymaps** (defined in `init.lua`):
| Keymap | Action |
|--------|--------|
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bc` | Close current buffer |
| `<leader>bb` | Pick buffer by letter |
| `<leader>bo` | Close all except current |

**Features**:
- Git status indicators (via gitsigns)
- File type icons (via nvim-web-devicons)
- Clickable tabs
- Auto-hides with neo-tree open

---

### 4. **obsidian.nvim** - Note Taking

**Purpose**: Manage Obsidian vaults directly in Neovim

**File**: `lua/custom/plugins/obsidian.lua`

**Configuration**:
```lua
workspaces = {
  { name = 'personal', path = '~/Documents/obsidian/personal' }
}
```

**Keymaps** (only in markdown files):
| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>os` | Obsidian search | Live grep in vault (fzf-lua) |
| `<leader>of` | Follow link | Jump to linked note |
| `<leader>od` | Toggle checkbox | Toggle markdown checkboxes |
| `<leader>onn` | New note | Create new note |
| `<leader>ont` | New from template | Create note from template |

**Templates**:
- Folder: `Templates/` in vault
- Date format: `%Y-%m-%d`
- Time format: `%H:%M`

**Note ID Function**:
Converts titles to lowercase-kebab-case (e.g., "My Note" → "my-note")

---

### 5. **fzf-lua** - Fuzzy Finder

**Purpose**: Fast fuzzy finder (replaces Telescope)

**File**: Configured in `init.lua` (lines ~600-680)

**Keymaps**:
| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>ff` | Find files | Search all files |
| `<leader>fg` | Live grep | Search in file contents |
| `<leader>fw` | Grep word | Search current word |
| `<leader>fh` | Help tags | Search help docs |
| `<leader>fk` | Keymaps | Search keymaps |
| `<leader>fd` | Diagnostics | Search LSP diagnostics |
| `<leader>fr` | Resume | Resume last search |
| `<leader>fo` | Old files | Recent files |
| `<leader><leader>` | Buffers | Switch buffers |
| `<leader>f/` | Fuzzy in buffer | Search in current file |
| `<leader>s/` | Grep open files | Search across open files |
| `<leader>sn` | Neovim config | Search config files |
| `<leader>fW` | Project grep | Full project search |

**Preview Layout**:
- Horizontal: Preview on right (75% width)
- Window: 95% of screen size

---

### 6. **nvim-ufo** - Advanced Folding

**Purpose**: Better code folding with Treesitter

**File**: `lua/custom/plugins/ufo.lua`

**Providers**: Treesitter → Indent (fallback)

**Keymaps**:
| Keymap | Action |
|--------|--------|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zr` | Open folds except comments/imports |
| `K` (on fold) | Peek fold content |

**Settings**:
- Fold column: 1 character wide
- Start with all folds open (level 99)

---

### 7. **neo-tree.nvim** - File Explorer

**Purpose**: File system browser

**File**: `lua/kickstart/plugins/neo-tree.lua`

**Keymap**:
| Keymap | Action |
|--------|--------|
| `\\` | Toggle file explorer |

**Behavior**:
- Auto-closes when file is opened
- Press `\\` again inside tree to close

---

### 8. **toggleterm.nvim** - Terminal

**Purpose**: Integrated terminal emulator

**File**: `lua/custom/plugins/init.lua`

**Configuration**:
- Size: 15 lines
- Direction: horizontal
- Floating terminal support for LazyGit

**Keymaps**:
| Keymap | Action |
|--------|--------|
| `<C-\>` | Toggle terminal |
| `<leader>tt` | Open terminal 1 |
| `<leader>t2` | Open terminal 2 |
| `<leader>tn` | Rotate through terminals (1-3) |
| `<leader>gg` | Toggle LazyGit (floating) |
| `<Esc><Esc>` | Exit terminal mode |

**LazyGit Integration**:
```lua
vim.keymap.set('n', '<leader>gg', function()
  require('toggleterm.terminal').Terminal:new({
    cmd = 'lazygit',
    hidden = true,
    direction = 'float',
  }):toggle()
end)
```

---

### 9. **Comment.nvim** - Smart Comments

**Purpose**: Context-aware commenting with Treesitter

**File**: `lua/custom/plugins/init.lua`

**Keymaps**:
| Mode | Keymap | Action |
|------|--------|--------|
| Normal | `<leader>/` | Toggle comment on line |
| Visual | `<leader>/` | Toggle comment on selection |

**Features**:
- Auto-detects comment syntax per language
- Respects JSX/TSX context (uses `{/* */}` in JSX)
- Integration with nvim-ts-context-commentstring

---

### 10. **multiple-cursors.nvim** - Multi-Cursor

**Purpose**: VSCode-like multi-cursor editing

**File**: `lua/custom/plugins/init.lua`

**Keymaps**:
| Keymap | Action |
|--------|--------|
| `<D-M-j>` or `<D-M-Down>` | Add cursor down |
| `<D-M-k>` or `<D-M-Up>` | Add cursor up |
| `<C-LeftMouse>` | Add/remove cursor at click |
| `<leader>m` (visual) | Add cursors to visual lines |
| `<leader>d` | Add cursor at next match |
| `<leader>D` | Jump to next match |
| `<leader>l` | Lock virtual cursors |

---

### 11. **Other Plugins**

#### better-escape.nvim
**Keymap**: `jj` → Exit insert mode

#### nvim-autopairs
Auto-closes brackets, quotes, etc.

#### nvim-ts-autotag
Auto-closes HTML/JSX/Vue tags.

#### precognition.nvim
Shows motion hints on screen.

#### neoscroll.nvim
Smooth scrolling animations.

#### smear-cursor.nvim
Smooth cursor motion trail.

#### mini.nvim Modules
- **mini.ai**: Enhanced text objects (va), yinq, ci')
- **mini.surround**: Add/delete/replace surroundings (saiw), sd', sr)')
- **mini.statusline**: Simple statusline

#### noice.nvim + nvim-notify
Modern UI for messages, cmdline, and notifications.

---

## 🗝️ Key Mappings Reference

### Leader Key: `<Space>`

### Navigation & Motion

| Keymap | Mode | Action |
|--------|------|--------|
| `<C-h/j/k/l>` | Normal | Move between splits |
| `<left/right/up/down>` | Normal | Disabled (shows warning) |
| `<Esc>` | Normal | Clear search highlight |

### File Operations

| Keymap | Mode | Action |
|--------|------|--------|
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Close file |
| `\\` | Normal | Toggle file tree |

### Buffers

| Keymap | Mode | Action |
|--------|------|--------|
| `<leader>bn` | Normal | Next buffer |
| `<leader>bp` | Normal | Previous buffer |
| `<leader>bc` | Normal | Close buffer |
| `<leader>bb` | Normal | Pick buffer |
| `<leader>bo` | Normal | Close all except current |

### Search & Find

| Keymap | Mode | Action |
|--------|------|--------|
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fw` | Normal | Find word under cursor |
| `<leader>fo` | Normal | Recent files |
| `<leader><leader>` | Normal | Find buffers |

### LSP

| Keymap | Mode | Action |
|--------|------|--------|
| `gd` | Normal | Go to definition |
| `grn` | Normal | Rename symbol |
| `gra` | Normal | Code action |
| `grr` | Normal | Find references |
| `gri` | Normal | Find implementations |
| `<leader>Y` | Normal | Copy diagnostic message |

### Editing

| Keymap | Mode | Action |
|--------|------|--------|
| `<leader>/` | Normal/Visual | Toggle comment |
| `<Tab>` | Visual | Indent |
| `<S-Tab>` | Visual | Unindent |
| `<leader>rw` | Normal | Replace word (confirm) |
| `<leader>rW` | Normal | Replace word (direct) |
| `jj` | Insert | Exit insert mode |

### Splits & Windows

| Keymap | Mode | Action |
|--------|------|--------|
| `<leader>\|` | Normal | Vertical split |
| `<leader>_` | Normal | Horizontal split |
| `<leader>H` | Normal | Decrease width |
| `<leader>L` | Normal | Increase width |
| `<leader>J` | Normal | Decrease height |
| `<leader>K` | Normal | Increase height |
| `<leader>R` | Normal | Enter resize mode (hjkl) |

### Terminal

| Keymap | Mode | Action |
|--------|------|--------|
| `<C-\>` | Normal | Toggle terminal |
| `<leader>tt` | Normal | Terminal 1 |
| `<leader>t2` | Normal | Terminal 2 |
| `<leader>tn` | Normal | Next terminal |
| `<leader>gg` | Normal | LazyGit |
| `<Esc><Esc>` | Terminal | Exit terminal mode |

### AI Assistants

| Keymap | Mode | Action |
|--------|------|--------|
| `<C-l>` | Insert | Accept Copilot |
| `<C-h>` | Insert | Dismiss Copilot |
| `<M-]>` | Insert | Next Copilot suggestion |
| `<M-[>` | Insert | Previous Copilot suggestion |
| (Avante) | See `:h avante` | Avante chat keymaps |

### Obsidian (Markdown Only)

| Keymap | Mode | Action |
|--------|------|--------|
| `<leader>os` | Normal | Search notes |
| `<leader>of` | Normal | Follow link |
| `<leader>od` | Normal | Toggle checkbox |
| `<leader>onn` | Normal | New note |
| `<leader>ont` | Normal | New from template |

### Templates

| Keymap | Mode | Action |
|--------|------|--------|
| `<leader>vt` | Normal | Insert Vue template |

### Folding

| Keymap | Mode | Action |
|--------|------|--------|
| `zR` | Normal | Open all folds |
| `zM` | Normal | Close all folds |
| `zr` | Normal | Open folds (smart) |
| `K` | Normal | Peek fold |

---

## 🔧 Development Workflow

### Adding a New Plugin

1. **Create plugin file**:
   ```bash
   touch lua/custom/plugins/my-plugin.lua
   ```

2. **Basic structure**:
   ```lua
   return {
     'author/plugin-name',
     event = 'VeryLazy',  -- or 'BufEnter', 'InsertEnter', etc.
     dependencies = { 'other/plugin' },
     opts = {
       -- options here
     },
     config = function(_, opts)
       require('plugin-name').setup(opts)
       -- custom keymaps or logic
     end,
   }
   ```

3. **Require in init.lua**:
   ```lua
   require 'custom.plugins.my-plugin',
   ```

4. **Restart Neovim**: Lazy.nvim auto-installs on startup

### Modifying Existing Plugin

1. Edit the plugin file in `lua/custom/plugins/` or relevant section in `init.lua`
2. Reload config: `:source $MYVIMRC` or restart Neovim
3. Update plugins: `:Lazy sync`

### Adding Keymaps

**Global keymaps** in `init.lua`:
```lua
vim.keymap.set('n', '<leader>x', ':SomeCommand<CR>', { desc = 'Description' })
```

**Plugin-specific keymaps** in plugin file:
```lua
config = function()
  vim.keymap.set('n', '<leader>x', function()
    require('plugin').action()
  end, { desc = 'Description' })
end
```

**Buffer-local keymaps** (e.g., markdown-only):
```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('n', '<leader>x', action, { buffer = true })
  end,
})
```

### LSP Server Setup

1. **Add to servers table** in `init.lua`:
   ```lua
   local servers = {
     your_ls = {
       settings = {
         -- server-specific settings
       },
     },
   }
   ```

2. **Install via Mason**:
   - Auto-installed if in `ensure_installed`
   - Or run `:Mason` and install manually

3. **Verify**:
   - Open file of that type
   - Check `:LspInfo`

### Formatter Configuration

Add to conform.nvim formatters_by_ft in `init.lua`:
```lua
formatters_by_ft = {
  filetype = { 'formatter_name' },
}
```

Install formatter via Mason or system package manager.

### Debugging

- **Check health**: `:checkhealth`
- **LSP status**: `:LspInfo`
- **Plugin status**: `:Lazy`
- **Mason tools**: `:Mason`
- **Treesitter**: `:TSInstallInfo`
- **Logs**: `~/.local/state/nvim/`

---

## 📦 External Dependencies

### Required Tools

#### Core
- **Neovim** >= 0.10 (nightly or stable)
- **Git**
- **Make**
- **C Compiler** (gcc/clang)
- **unzip**

#### Fuzzy Finding
- **ripgrep** (rg) - Fast grep
- **fd-find** (fd) - Fast file finder

#### Clipboard
- **xclip** (Linux)
- **xsel** (Linux alternative)
- **win32yank** (Windows)
- **pbcopy/pbpaste** (macOS - built-in)

#### Optional
- **Nerd Font** - For icons (set `vim.g.have_nerd_font = true`)
- **lazygit** - Git TUI (`<leader>gg`)
- **Node.js + npm** - For TypeScript LSP
- **prettierd** - Fast formatting

### LSP Server Installation

All managed via **Mason**. Run `:Mason` to install:

**Pre-configured servers**:
- `lua_ls` (Lua)
- `vtsls` (TypeScript/JavaScript)
- `vue_ls` (Vue.js)

**Install others manually** in Mason UI.

### Formatters & Linters

**Auto-installed**:
- `stylua` (Lua)

**Recommended** (install via Mason):
- `prettierd` (JS/TS/Vue/CSS/HTML)
- `markdownlint` (Markdown)

### AI Services

#### GitHub Copilot
Requires:
1. GitHub Copilot subscription
2. Run `:Copilot auth` on first use

#### Avante (Moonshot/Kimi)
Requires:
1. API key in environment: `MOONSHOT_API_KEY`
2. Or configure in `lua/custom/plugins/avante.lua`:
   ```lua
   moonshot = {
     api_key_name = 'your_key_here', -- or use env var
   }
   ```

Alternatively, switch to OpenAI:
```lua
provider = 'openai',
-- Set OPENAI_API_KEY environment variable
```

---

## 🔍 Troubleshooting

### Common Issues

#### 1. LSP Not Working

**Symptoms**: No autocompletion, go-to-definition fails

**Solutions**:
```vim
:LspInfo              " Check if LSP attached
:Mason                " Verify servers installed
:checkhealth lsp      " Check LSP health
```

- Ensure file type detected: `:set filetype?`
- Reinstall server: `:MasonUninstall <server>` → `:MasonInstall <server>`

#### 2. Copilot Not Suggesting

**Solutions**:
```vim
:Copilot status       " Check authentication
:Copilot auth         " Re-authenticate
```

- Check network connection
- Verify subscription at github.com/settings/copilot

#### 3. Treesitter Errors

**Symptoms**: `TSUpdate` fails, syntax highlighting broken

**Solutions**:
```vim
:TSInstall <language>
:TSUpdate
```

- Ensure C compiler installed
- Check `:checkhealth nvim-treesitter`

#### 4. Formatter Not Running

**Symptoms**: File not auto-formatted on save

**Solutions**:
- Check formatter installed: `:Mason`
- Verify filetype configured in `formatters_by_ft`
- Check `:ConformInfo` for status
- Ensure `format_on_save` not disabled for your filetype

#### 5. Keybind Not Working

**Solutions**:
- Check keymap registered: `:map <leader>x`
- Verify no conflicts: `:verbose map <key>`
- Check which-key help: `<leader>` then wait

#### 6. Plugins Not Loading

**Solutions**:
```vim
:Lazy sync            " Sync plugins
:Lazy clean           " Remove unused
:Lazy restore         " Restore from lockfile
```

- Check `lazy-lock.json` exists
- Delete `~/.local/share/nvim/lazy/` to reinstall all

#### 7. Neo-tree Won't Open

**Symptom**: `\\` does nothing

**Solutions**:
- Check if already open in another tab
- Try `:Neotree reveal`
- Verify plugin loaded: `:Lazy`

#### 8. Avante Chat Not Working

**Solutions**:
- Check API key set: `echo $MOONSHOT_API_KEY`
- Verify provider config in `lua/custom/plugins/avante.lua`
- Check network proxy if behind firewall
- View logs: `:messages`

#### 9. Folding Issues

**Symptoms**: Folds not working, entire file folded

**Solutions**:
- Check foldmethod: `:set foldmethod?` (should be `expr`)
- Reload Treesitter: `:edit`
- Open all folds: `zR`
- Disable ufo temporarily: comment out plugin

#### 10. Obsidian Notes Not Found

**Solutions**:
- Verify vault path: `~/Documents/obsidian/personal`
- Check file permissions
- Ensure in markdown file for keymaps
- Try `:ObsidianWorkspace` to switch

### Performance Issues

#### Slow Startup

1. **Profile startup**:
   ```bash
   nvim --startuptime startup.log
   ```

2. **Lazy-load more plugins**: Add `lazy = true` or `event = 'VeryLazy'`

3. **Check health**:
   ```vim
   :checkhealth lazy
   ```

#### Slow Editing

- Disable Copilot temporarily: `:Copilot disable`
- Check Treesitter: `:TSBufDisable highlight`
- Reduce `updatetime`: `vim.o.updatetime = 500`

### Getting Help

1. **Built-in help**:
   ```vim
   :help <topic>
   :Tutor
   ```

2. **Plugin help**:
   ```vim
   :help lazy.nvim
   :help lspconfig
   :help blink-cmp
   ```

3. **Check logs**:
   - Neovim: `~/.local/state/nvim/log`
   - LSP: `:LspLog`

4. **Community**:
   - [Neovim Discourse](https://neovim.discourse.group/)
   - [r/neovim](https://reddit.com/r/neovim)
   - Plugin GitHub issues

---

## 📝 Configuration Philosophy

### Single-file vs Modular

This config uses a **hybrid approach**:

- ✅ **Single `init.lua`**: Core settings, built-in plugins, LSP config
- ✅ **Modular plugins**: Custom plugins in `lua/custom/plugins/`

**Why?**
- Easy to understand for newcomers (kickstart philosophy)
- Modular enough to organize custom additions
- Balance between simplicity and organization

### When to Split Config

Consider splitting if:
- `init.lua` exceeds 1500+ lines
- You have 10+ custom plugins
- Multiple developers maintaining

Example modular structure:
```
lua/
├── config/
│   ├── options.lua
│   ├── keymaps.lua
│   ├── autocmds.lua
│   └── lazy.lua
├── plugins/
│   ├── lsp.lua
│   ├── completion.lua
│   ├── ui.lua
│   └── ...
```

See [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim) for example.

---

## 🎨 Customization Tips

### Changing Colorscheme

1. **Uncomment a theme** in `init.lua` (lines ~1100-1150):
   ```lua
   {
     'folke/tokyonight.nvim',
     priority = 1000,
     config = function()
       vim.cmd.colorscheme 'tokyonight-night'
     end,
   },
   ```

2. **Comment out current theme** (bluloco)

3. **Restart Neovim**

### Adding Language Support

1. **Install LSP server** via Mason:
   ```vim
   :Mason
   ```

2. **Add Treesitter parser**:
   ```vim
   :TSInstall <language>
   ```

3. **(Optional) Add formatter** in `formatters_by_ft`

### Adjusting AI Providers

**Switch to OpenAI**:
```lua
-- In lua/custom/plugins/avante.lua
opts = {
  provider = 'openai',
  providers = {
    openai = {
      model = 'gpt-4-turbo',
      api_key_name = 'OPENAI_API_KEY',
    },
  },
}
```

**Add Claude**:
```lua
provider = 'claude',
providers = {
  claude = {
    endpoint = 'https://api.anthropic.com',
    model = 'claude-sonnet-4-20250514',
    api_key_name = 'ANTHROPIC_API_KEY',
  },
}
```

---

## 📚 Additional Resources

### Learning Neovim
- **Built-in tutorial**: `:Tutor`
- **Help system**: `:help` (start here!)
- **Help search**: `<leader>sh` (fuzzy search help)

### Lua Programming
- [Lua in Y minutes](https://learnxinyminutes.com/docs/lua/)
- [Neovim Lua guide](https://neovim.io/doc/user/lua-guide.html)
- `:help lua-guide`

### Plugin Development
- [Lazy.nvim docs](https://lazy.folke.io/)
- [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- `:help lua-guide`

### Community Configs
- [LazyVim](https://www.lazyvim.org/)
- [AstroNvim](https://astronvim.com/)
- [NvChad](https://nvchad.com/)

---

## 🚀 Quick Start for New Developers

### Day 1: Basic Usage

1. **Open Neovim**: `nvim`
2. **File explorer**: `\\`
3. **Find files**: `<leader>ff`
4. **Save**: `<leader>w`
5. **Close**: `<leader>q`

### Week 1: Learn Keymaps

- Print this cheat sheet or use `<leader>` + wait for which-key
- Practice motions: `hjkl`, `w`, `b`, `{`, `}`
- Master fuzzy finding: `<leader>ff`, `<leader>fg`

### Month 1: Customize

- Explore `init.lua` top-to-bottom
- Add your first keymap
- Install a new LSP server
- Tweak colorscheme

### Ongoing: Stay Updated

```bash
# Update plugins
nvim -c "Lazy sync" -c "qa"

# Update Mason tools
nvim -c "MasonUpdate" -c "qa"
```

---

## 📞 Handover Checklist

### For Outgoing Developer

- [ ] Document any custom keymaps not in this file
- [ ] Note any local-only settings (e.g., work-specific LSP configs)
- [ ] Export Mason tool list: `:MasonLog`
- [ ] Commit any uncommitted changes
- [ ] Update `diff.txt` with recent changes summary
- [ ] Share any external API keys (securely)

### For Incoming Developer

- [ ] Install external dependencies (see [External Dependencies](#-external-dependencies))
- [ ] Clone this config to `~/.config/nvim`
- [ ] Open Neovim (plugins auto-install)
- [ ] Run `:checkhealth`
- [ ] Authenticate Copilot: `:Copilot auth`
- [ ] Set `MOONSHOT_API_KEY` or `OPENAI_API_KEY` environment variable
- [ ] Read `init.lua` top-to-bottom
- [ ] Run `:Tutor` if new to Neovim
- [ ] Practice keymaps with real project

---

## 🔖 Version History

### Current State (2025-01)
- **Base**: kickstart.nvim (latest)
- **Neovim**: 0.10+
- **LSP**: vtsls, vue_ls, lua_ls
- **Completion**: blink.cmp (v1.x)
- **AI**: copilot.lua + avante.nvim (Moonshot provider)
- **Theme**: bluloco.nvim

### Recent Major Changes (see `diff.txt`)
- Switched from Telescope to fzf-lua (faster)
- Added Avante.nvim with custom shortcuts
- Configured Vue.js + TypeScript hybrid LSP
- Added nvim-ufo for better folding
- Integrated Obsidian.nvim for note-taking

---

## 🤝 Contributing

### Making Changes

1. Test changes in a branch or fork
2. Update this `AGENTS.md` if adding features
3. Run `:checkhealth` before committing
4. Use commit message conventions (see Avante `commit_309` shortcut)

### Commit Message Format

```
<type>(<scope>): <description>

[optional body]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`

Example:
```
feat(lsp): add rust analyzer support
docs(readme): update installation steps
fix(keymap): resolve conflict with <leader>x
```

---

## 📄 License

Same as kickstart.nvim: **MIT License**

See `LICENSE.md` for details.

---

## 🙏 Acknowledgments

- **kickstart.nvim**: TJ DeVries and contributors
- **Neovim**: Core team
- **Plugin authors**: See individual plugin repos for credits

---

**Last Updated**: 2025-11-14
**Maintained By**: Development Team
**Contact**: See project repository

---

## 💡 Pro Tips

### Efficiency Hacks

1. **Disable arrow keys** - Forces hjkl mastery (already configured)
2. **Use relative numbers** - Jump with `5j`, `12k` (enabled)
3. **Master text objects** - `ci"`, `da(`, `viw` (mini.ai enhances these)
4. **Visual block mode** - `<C-v>` for column editing
5. **Repeat last action** - `.` key
6. **Jump list** - `<C-o>` back, `<C-i>` forward
7. **Marks** - `ma` to mark, `` `a `` to jump back

### AI Assistance Workflow

1. **Inline suggestions**: Let Copilot auto-suggest, press `<C-l>` to accept
2. **Chat for refactoring**: Select code (visual), open Avante, ask to refactor
3. **Commit messages**: Stage changes, select diff, run Avante `commit_309` shortcut
4. **Documentation**: Select function, ask Avante to document

### Git Workflow with LazyGit

1. Press `<leader>gg`
2. Stage files: `Space`
3. Commit: `c` → write message → save
4. Push: `P`
5. Pull: `p`
6. View diffs: `Enter` on file

### Obsidian Workflow

1. Open vault file: `<leader>ff` → search in `~/Documents/obsidian/`
2. Or search content: `<leader>os`
3. Follow links: `<leader>of`
4. Create new note: `<leader>onn`
5. Templates: `<leader>ont`

---

**End of Handover Document**

This document should be updated as the configuration evolves. Keep it in sync with actual `init.lua` and plugin files.

