--- Project Terminal Floating Window Plugin
local M = {}

--- Find the project root directory
---@return string|nil The root directory of the project
local function find_project_root()
  -- Try to find project root using common markers
  local root_markers = {
    '.git',
    'Makefile',
    'pyproject.toml',
    'package.json',
    'go.mod',
    'pom.xml',
  }

  -- Get the directory of the current buffer
  local current_dir = vim.fn.expand '%:p:h'

  -- Traverse up the directory tree
  while current_dir ~= '/' do
    for _, marker in ipairs(root_markers) do
      if vim.fn.filereadable(current_dir .. '/' .. marker) ~= 0 or vim.fn.isdirectory(current_dir .. '/' .. marker) ~= 0 then
        return current_dir
      end
    end
    -- Move up one directory
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end

  -- Fallback to current working directory
  return vim.fn.getcwd()
end

--- Create and open a floating terminal
function M.open_floating_terminal()
  -- Find the project root
  local project_root = find_project_root()

  -- Configure floating window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.7)

  -- Calculate window position to center it
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create buffer for the terminal
  local buf = vim.api.nvim_create_buf(false, true)

  -- Configure window options
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Open terminal in the project root directory
  vim.fn.termopen('cd ' .. project_root .. ' && $SHELL', {
    on_exit = function()
      -- Close window when terminal exits
      vim.api.nvim_win_close(win, true)
    end,
  })

  -- Enter terminal mode
  vim.cmd 'startinsert'
end

--- Setup function for the plugin
function M.setup()
  -- Create a user command to open the floating terminal
  vim.api.nvim_create_user_command('Terminal', M.open_floating_terminal, {})
end

return M
