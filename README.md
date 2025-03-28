# terminal.nvim

A minimal floating terminal plugin for Neovim that automatically detects and opens in your project root directory.

## Features

- Floating terminal window with customizable dimensions
- Automatic project root detection based on common markers (.git, package.json, etc.)
- Clean and minimal UI with rounded borders
- Simple keybinding integration

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    'yourusername/terminal.nvim',
    config = function()
        require('terminal').setup()
    end,
    keys = {
        { "<leader>tt", "<cmd>Terminal<cr>", desc = "Open Floating Terminal" },
    },
}
```

## Configuration

Default configuration:

```lua
{
    -- Window dimensions as percentage of editor size
    width = 0.8,
    height = 0.7,
    -- Window appearance
    border = 'rounded',
    style = 'minimal',
    -- Root directory markers
    root_markers = {
        '.git',
        'Makefile',
        'pyproject.toml',
        'package.json',
        'go.mod',
        'pom.xml',
    },
}
```

## License

MIT