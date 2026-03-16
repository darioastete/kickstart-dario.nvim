# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Heavily customized Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), targeting TypeScript/Vue.js development with deep AI integration (Copilot + Avante.nvim).

## Common Commands

```bash
# Format Lua files
stylua .

# Check formatting without applying (CI equivalent)
stylua --check .
```

The CI pipeline (`.github/workflows/stylua.yml`) runs `stylua --check` on all `.lua` files. All Lua must pass this before merging.

Stylua config is in `.stylua.toml` — respect its settings (indent width, quote style, etc.) when editing Lua.

## Architecture

### Three-tier plugin system

1. **`init.lua`** — Core settings, keymaps, and ~50 plugin specs configured inline. This is the source of truth for LSP, completion, formatting, and all base functionality.

2. **`lua/kickstart/plugins/`** — Upstream kickstart.nvim plugin files (autopairs, gitsigns, neo-tree, lint, indent_line). Treat as semi-canonical; modify carefully.

3. **`lua/custom/plugins/`** — Per-plugin files for heavier customizations:
   - `avante.lua` — AI assistant (Moonshot/Kimi provider), custom shortcuts for conventional commits (Spanish) and DRY/KISS refactoring
   - `obsidian.lua` — Vault integration at `~/Documents/obsidian/personal`, markdown-only keymaps via `FileType` autocmd
   - `barbar.lua` — Buffer tabline
   - `ufo.lua` — Advanced folding via Treesitter
   - `auto-tag.lua` — HTML/JSX auto-tags
   - `nvim-cmp.lua`, `mcphub.lua`, `snacks.lua` — Inactive/minimal configs

### Key technology choices

- **fzf-lua** (not Telescope) for all fuzzy finding
- **blink.cmp** (not nvim-cmp) for completion
- **vtsls** (not tsserver) for TypeScript LSP; **vue_ls** for Vue
- **Vue+TS hybrid mode**: `vtsls` is configured with Vue plugin to handle `.vue` files alongside `vue_ls`
- **conform.nvim** for formatting (prettierd for JS/TS/Vue/CSS, stylua for Lua)
- **Avante.nvim** primary provider: Moonshot (`MOONSHOT_API_KEY` env var required)

### LSP pattern

LSP servers are declared in the `servers` table in `init.lua` and auto-installed via Mason. The Vue/TS hybrid wiring is handled inline in the LSP on_attach area — both `vue_ls` and `vtsls` are needed simultaneously for `.vue` files.

### Lazy loading conventions

```lua
event = 'VeryLazy'   -- non-critical UI plugins
event = 'BufEnter'   -- buffer-dependent plugins
keys = { ... }       -- load on first keypress
ft = 'markdown'      -- filetype-specific plugins
```

## External Dependencies

Required tools (must be installed system-wide):
- `ripgrep` (rg) — fzf-lua grep
- `fd` — fzf-lua file finding
- `stylua` — Lua formatter
- `prettierd` — JS/TS/Vue formatter (faster prettier daemon)
- `lazygit` — floating git UI (`<leader>gg`)

LSP servers installed automatically via Mason on first launch.
