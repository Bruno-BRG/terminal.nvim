# terminal.nvim

A minimal floating terminal plugin for Neovim that automatically detects and opens in your project root directory. Perfect for users who want a clean, distraction-free terminal experience within their editor.

## ✨ Features

- 🪟 Floating terminal window with customizable dimensions
- 📁 Smart project root detection based on common project markers
- 🎨 Clean and minimal UI with rounded borders
- ⚡ Zero dependencies - just pure Neovim
- 🔧 Fully configurable through setup options
- 🔍 Automatically opens in the detected project root directory

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'Bruno-BRG/terminal.nvim',
    config = function()
        require('terminal').setup({
            -- Your custom config here (optional)
        })
    end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'Bruno-BRG/terminal.nvim',
    config = function()
        require('terminal').setup()
    end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'Bruno-BRG/terminal.nvim'
```

## ⚡ Quick Start

1. Install the plugin using your preferred package manager
2. Add basic configuration to your `init.lua`:

```lua
require('terminal').setup()

-- Recommended keymaps
vim.keymap.set('n', '<leader>tt', '<cmd>Terminal<cr>', { desc = 'Open floating terminal' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
```

## ⚙️ Configuration

Here's the default configuration with all available options:

```lua
require('terminal').setup({
    -- Window dimensions (as percentage of editor size)
    width = 0.8,
    height = 0.7,
    
    -- Window appearance
    border = 'rounded', -- none, single, double, rounded, solid, shadow
    style = 'minimal',  -- minimal, default
    
    -- Project root detection markers
    root_markers = {
        '.git',
        'Makefile',
        'pyproject.toml',
        'package.json',
        'go.mod',
        'pom.xml',
    },
})
```

## 🔍 Root Directory Detection

The plugin automatically detects your project's root directory by looking for common project markers. If no markers are found, it falls back to the current working directory.

Supported markers:
- `.git` directory
- `Makefile`
- `pyproject.toml`
- `package.json`
- `go.mod`
- `pom.xml`

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Credits

Created and maintained by [Bruno-BRG](https://github.com/Bruno-BRG).

## 📣 Feedback and Issues

If you encounter any problems or have suggestions, please [open an issue](https://github.com/Bruno-BRG/terminal.nvim/issues) on GitHub.