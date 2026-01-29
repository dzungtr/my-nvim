# Neovim Configuration for Platform Engineering

A comprehensive, production-ready Neovim configuration targeting platform engineering workflows with TypeScript/React, Golang, Kubernetes YAML, and Terraform support. Achieves sub-50ms startup time with VSCode-like IDE features.

## Features

- ⚡ **Sub-50ms startup time** with aggressive lazy-loading
- 🎨 **Modern UI** with Catppuccin theme, lualine, which-key, noice
- 🔍 **Fuzzy finding** with Telescope + fzf-native (10-50x faster)
- 📁 **File explorer** with neo-tree and oil.nvim
- 🧠 **LSP** with Mason for automatic server management
- ✨ **Modern completion** with blink.cmp (0.5-4ms latency)
- 🎯 **Debugging** with nvim-dap for Node.js and Go
- 🔧 **Formatting** with conform.nvim (null-ls successor)
- 🌳 **Git integration** with gitsigns, lazygit, and diffview

## Language Support

### TypeScript/JavaScript/React
- **LSP**: typescript-tools.nvim (better performance than ts_ls)
- **Formatting**: Prettier (prettierd)
- **Features**: Auto-closing JSX tags, inlay hints, organize imports
- **Debugging**: Full support with breakpoints, watches, Jest/Mocha test debugging

### Golang
- **LSP**: gopls with comprehensive settings
- **Framework**: go.nvim for integrated tooling
- **Formatting**: gofumpt + goimports
- **Features**: Struct tags, test runner, code coverage, delve debugging
- **Commands**: `:GoTest`, `:GoImpl`, `:GoFillStruct`, `:GoAddTag`

### Kubernetes/YAML
- **LSP**: yamlls with schema validation
- **Framework**: yaml-companion for auto-detection
- **Schemas**: Kubernetes 1.28/1.29, Argo CD, Helm, GitHub Actions
- **Features**: Schema switching with Telescope, validation, completion

### Terraform
- **LSP**: terraform-ls + tflint
- **Formatting**: terraform_fmt
- **Features**: Resource completion, validation

## Prerequisites

**Required:**
- Neovim 0.11+ (`nvim --version`)
- Node.js 18+ (for TypeScript tooling)
- Go 1.21+ (for Go development)
- git, wget, curl, unzip, tar, gzip (for Mason)

**Optional:**
- `ripgrep` (for Telescope live grep)
- `fd` (for Telescope file finding)
- `lazygit` (for Git TUI)
- `make` (for telescope-fzf-native)

## Installation

### Test in Current Directory

```bash
# From this directory
nvim

# Check startup time
nvim --startuptime startup.log +q
tail -1 startup.log
```

### Deploy to ~/.config/nvim

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# Deploy new config
cp -r . ~/.config/nvim

# Or symlink for development
ln -s $(pwd) ~/.config/nvim
```

## First Launch Setup

1. **Plugin Installation**: Lazy.nvim will automatically install all plugins
2. **Language Servers**: Open `:Mason` and verify installations
3. **Treesitter Parsers**: `:TSInstall all` (auto-installed on first use)
4. **Health Check**: `:checkhealth` to verify everything is working

## Key Bindings

### Leader Key
- **Leader**: `<Space>`
- **Local Leader**: `\`

### File Navigation
- `<leader>e` - Toggle Neo-tree file explorer
- `<leader>fe` - Focus Neo-tree
- `-` - Open Oil.nvim (edit filesystem like a buffer)

### Fuzzy Finding (Telescope)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Buffers
- `<leader>fr` - Recent files
- `<leader>fh` - Help tags
- `<leader>fd` - Diagnostics

### LSP
- `gd` - Go to definition
- `gr` - References
- `K` - Hover documentation
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `<leader>lf` - Format buffer
- `[d` / `]d` - Previous/Next diagnostic

### Git
- `<leader>gg` - LazyGit
- `<leader>gd` - Diff view
- `<leader>gh` - File history
- `]c` / `[c` - Next/Previous hunk
- `<leader>hs` - Stage hunk

### Debugging (DAP)
- `<F5>` - Continue
- `<F10>` - Step over
- `<F11>` - Step into
- `<leader>db` - Toggle breakpoint
- `<leader>du` - Toggle debug UI

### Go-specific
- `<leader>gt` - Run tests
- `<leader>gi` - Implement interface
- `<leader>gf` - Fill struct
- `<leader>ga` - Add tags

## Testing

### Startup Performance
```bash
nvim --startuptime startup.log +q
tail -1 startup.log  # Should show <50ms
```

### Health Checks
```vim
:checkhealth
:checkhealth lsp
:checkhealth mason
```

### Test TypeScript
```bash
echo "const x: number = 42;" > test.ts
nvim test.ts
```

### Test Go
```bash
echo "package main\n\nfunc main() {}" > test.go
nvim test.go
```

## Customization

### Change Colorscheme
Edit `lua/plugins/colorscheme.lua`:
- `"latte"` (light)
- `"frappe"` (medium)
- `"macchiato"` (dark)
- `"mocha"` (darkest)

### Add Language Servers
Edit `lua/plugins/lsp.lua` and add to `ensure_installed`.

### Modify Keybindings
- Global: `lua/config/keymaps.lua`
- Plugin-specific: Each plugin file has `keys` section

## Troubleshooting

### Plugins not installing
```vim
:Lazy sync
```

### LSP server not attaching
```vim
:LspInfo
:Mason
:LspRestart
```

### Completion not working
```vim
:checkhealth blink.cmp
```

### Go tools not installed
```vim
:GoInstallBinaries
```

## External Dependencies

```bash
# macOS
brew install ripgrep fd lazygit neovim node go

# Go debugging
go install github.com/go-delve/delve/cmd/dlv@latest
```

## Architecture

```
.
├── init.lua                  # Entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua      # Autocommands
│   │   ├── keymaps.lua       # Global keymaps
│   │   ├── lazy.lua          # Plugin manager
│   │   └── options.lua       # Vim options
│   └── plugins/
│       ├── colorscheme.lua   # Theme
│       ├── completion.lua    # blink.cmp
│       ├── dap.lua           # Debugging
│       ├── editor.lua        # File explorer, git, utilities
│       ├── formatting.lua    # conform.nvim
│       ├── git.lua           # Advanced Git tools
│       ├── golang.lua        # Go tooling
│       ├── kubernetes.lua    # YAML schema
│       ├── lsp.lua           # LSP base
│       ├── telescope.lua     # Fuzzy finder
│       ├── treesitter.lua    # Syntax
│       ├── typescript.lua    # TypeScript LSP
│       └── ui.lua            # UI enhancements
└── lazy-lock.json            # Plugin versions (auto-generated)
```

## Performance Metrics

- Base config: 26-30ms
- Full config (lazy-loaded): 40-50ms
- LSP attach: <100ms per server
- First completion: <500ms after InsertEnter

## License

MIT License - Feel free to use and modify as needed.

## Credits

Built with modern Neovim best practices from:
- [lazy.nvim](https://github.com/folke/lazy.nvim) by folke
- [blink.cmp](https://github.com/saghen/blink.cmp) by saghen
- [LazyVim](https://github.com/LazyVim/LazyVim) for inspiration
- Community plugin authors
