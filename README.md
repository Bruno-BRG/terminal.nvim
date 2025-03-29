# terminal.nvim

A cross-platform floating terminal plugin for Neovim that automatically detects and opens in your project root directory. Perfect for users who want a clean, distraction-free terminal experience within their editor.

## ✨ Features

- 🪟 Floating terminal window with customizable dimensions
- 📁 Smart project root detection based on common project markers
- 🌍 Cross-platform support (Windows, Linux, macOS, and WSL)
- 🔄 Intelligent shell detection:
  - Windows: PowerShell (preferred) or cmd.exe
  - Unix: Uses default shell or falls back to bash
  - WSL: Proper WSL environment support
- 🎨 Clean and minimal UI with rounded borders
- ⚡ Zero dependencies - just pure Neovim
- 🔧 Fully configurable through setup options
- 🎯 Automatic project root directory detection
- 🎨 Proper terminal colors and UI integration

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'Bruno-BRG/terminal.nvim',
    config = function()
        require('Terminal').setup({
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
        require('Terminal').setup()
    end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'Bruno-BRG/terminal.nvim'
```

After installation, add to your init.vim/init.lua:
```lua
require('Terminal').setup()
```

## ⚡ Default Keymaps

The plugin comes with these default keymaps:

- `<leader>t`: Open floating terminal
- `<Esc><Esc>`: Exit terminal mode (while in terminal)

These keymaps are set up automatically when you call `setup()`.

## ⚙️ Configuration

Here's the default configuration with all available options:

```lua
require('Terminal').setup({
    -- Window dimensions (as percentage of editor size)
    width = 0.8,
    height = 0.7,
    
    -- Window appearance
    border = 'rounded', -- none, single, double, rounded, solid, shadow
    style = 'minimal',  -- minimal, default
    
    -- Project root detection markers (in order of priority)
    root_markers = {
        '.git',
        '.svn',
        '.hg',
        'Makefile',
        'package.json',
        'go.mod',
        'cargo.toml',
        'mix.exs',
        'pom.xml',
        'composer.json',
        '.projectile',
        '.project'
    },
})
```

## 🔍 Project Root Detection

The plugin intelligently detects your project's root directory by looking for common project markers in the following order:

1. Version Control Systems:
   - `.git` directory
   - `.svn` directory
   - `.hg` directory (Mercurial)

2. Build System & Package Managers:
   - `Makefile`
   - `package.json` (Node.js)
   - `go.mod` (Go)
   - `cargo.toml` (Rust)
   - `mix.exs` (Elixir)
   - `pom.xml` (Maven)
   - `composer.json` (PHP)

3. Project Files:
   - `.projectile` (Emacs projectile)
   - `.project` (Eclipse)

If no markers are found, it falls back to the current working directory.

## 🖥️ Platform-Specific Features

### Windows
- Prioritizes PowerShell Core (pwsh) if available
- Falls back to Windows PowerShell if PowerShell Core isn't available
- Uses cmd.exe as last resort
- Proper handling of drive letter changes with `cd /d`

### Unix-like Systems (Linux/macOS)
- Uses the user's default shell ($SHELL)
- Falls back to /bin/bash if $SHELL is not set
- Proper handling of login shell initialization

### WSL (Windows Subsystem for Linux)
- Detects WSL environment automatically
- Uses appropriate WSL shell with proper environment setup
- Maintains WSL-specific environment variables

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

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

If you encounter any problems or have suggestions:
1. Check the [Issues](https://github.com/Bruno-BRG/terminal.nvim/issues) page first
2. If your issue isn't already reported, [open a new issue](https://github.com/Bruno-BRG/terminal.nvim/issues/new)

## 🔄 Updates & Changelog

### Latest Updates
- Added comprehensive cross-platform support
- Improved project root detection with more markers
- Enhanced shell detection and initialization
- Added proper WSL support
- Improved terminal UI and color handling