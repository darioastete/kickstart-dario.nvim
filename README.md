# nvim config

Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), focused on TypeScript/Vue.js development with AI integration (Avante.nvim + Copilot).

---

## Prerequisites

### Neovim

```bash
brew install neovim
```

Requires the latest **stable** or **nightly** version.

### System tools

```bash
brew install ripgrep fd fzf stylua lazygit yazi node tree-sitter
```

| Tool | Purpose |
|------|---------|
| `ripgrep` | Text search across files (fzf-lua grep) |
| `fd` | File finder (fzf-lua files) |
| `fzf` | Fuzzy search engine |
| `stylua` | Lua formatter |
| `lazygit` | Floating Git UI (`<leader>gg`) |
| `yazi` | File manager (`\`) |
| `node` / `npm` | Required by TypeScript and Vue LSPs |
| `tree-sitter` | Treesitter parser compilation |

### JS/TS/Vue formatter

```bash
npm install -g @fsouza/prettierd
```

### Environment variables

```bash
# Required for Avante.nvim (Moonshot/Kimi provider)
export MOONSHOT_API_KEY="your-api-key"
```

---

## Installation

```bash
git clone https://github.com/your-username/nvim.git ~/.config/nvim
nvim  # Lazy installs all plugins automatically
```

LSPs, linters and formatters are installed automatically via **Mason** on first launch.

---

## LSPs (auto-installed via Mason)

| LSP | Language |
|-----|----------|
| `vtsls` | TypeScript / JavaScript |
| `vue_ls` | Vue.js |
| `tailwindcss` | TailwindCSS |
| `emmet_language_server` | HTML / JSX / Vue |
| `lua_ls` | Lua |

---

## Architecture

```
init.lua                        # Core: settings, keymaps, LSP, ~50 plugins inline
lua/kickstart/plugins/          # Base kickstart.nvim plugin files
lua/custom/plugins/             # Plugins with custom config
  ├── avante.lua                # AI assistant (Moonshot/Kimi)
  ├── barbar.lua                # Buffer tabline
  ├── obsidian.lua              # Obsidian vault integration
  └── init.lua                  # Remaining custom plugins
```

---

## Keymaps

### Files & search

| Key | Action |
|-----|--------|
| `\` | Open yazi at current file |
| `<leader>cw` | Open yazi at working directory |
| `<C-Up>` | Resume last yazi session |
| `<leader>ff` | Find files (fzf-lua) |
| `<leader>fg` | Search file contents (live grep) |
| `<leader>fo` | Recent files |
| `<leader>bb` | Buffer picker |

### Buffers

| Key | Action |
|-----|--------|
| `]b` | Next buffer |
| `[b` | Previous buffer |
| `<leader>bd` | Close buffer (keep window) |
| `<leader>bD` | Force close buffer |
| `<leader>bo` | Close all buffers except current |

### Motion (flash.nvim)

| Key | Action |
|-----|--------|
| `f/F/t/T` | Native motion with jump labels on matches |
| `s` | Jump anywhere on screen (2 chars) |
| `S` | Treesitter-based selection |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Open lazygit |

### Editor

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Close file |
| `<leader>rw` | Replace word under cursor (with confirmation) |
| `<leader>rW` | Replace word under cursor (no confirmation) |
| `<Tab>` / `<S-Tab>` | Indent / unindent selection (visual mode) |

### Splits

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate between splits |

---

## Formatting

Run manually:

```bash
# Format all Lua files
stylua .

# Check without applying (CI equivalent)
stylua --check .
```

The CI pipeline (`.github/workflows/stylua.yml`) runs `stylua --check` on all `.lua` files.

---

## FAQ

**How do I update plugins?**
```
:Lazy sync
```

**How do I install/update LSPs?**
```
:Mason
```

**How do I uninstall this configuration?**
```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```
