<<<<<<< HEAD
--- Project Terminal Floating Window Plugin
local M = {}

-- Platform detection helper functions
local is_windows = vim.fn.has('win32') == 1
local is_wsl = vim.fn.has('wsl') == 1
local path_sep = is_windows and '\\' or '/'

--- Get the appropriate shell command and args for the current OS
---@return string shell The shell executable path
---@return string[] args The shell arguments
local function get_shell_command()
  if is_windows then
    -- Windows: Prefer PowerShell if available, fallback to cmd.exe
    if vim.fn.executable('pwsh') == 1 then
      return 'pwsh', {'-NoLogo'}
    elseif vim.fn.executable('powershell') == 1 then
      return 'powershell', {'-NoLogo'}
    else
      return vim.fn.exists('$COMSPEC') == 1 and vim.fn.expand('$COMSPEC') or 'cmd.exe', {'/k'}
    end
  elseif is_wsl then
    -- WSL: Use the default shell but ensure proper environment
    local shell = os.getenv('SHELL') or '/bin/bash'
    return shell, {'-l'}
  else
    -- Unix-like systems (Linux/macOS)
    local shell = os.getenv('SHELL') or '/bin/bash'
    return shell, {'-l'}
  end
end

--- Normalize path for current OS
---@param path string The path to normalize
---@return string normalized_path The normalized path
local function normalize_path(path)
  if is_windows then
    return path:gsub('/', '\\')
  else
    return path:gsub('\\', '/')
  end
end

--- Find the project root directory
---@return string The root directory of the project
local function find_project_root()
  -- Common project markers across all platforms
  local root_markers = {
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
    '.project',
  }

  -- Get the directory of the current buffer
  local current_dir = vim.fn.expand('%:p:h')
  local initial_dir = current_dir

  -- Traverse up the directory tree
  while current_dir ~= '' do
    for _, marker in ipairs(root_markers) do
      local marker_path = normalize_path(current_dir .. path_sep .. marker)
      if vim.fn.filereadable(marker_path) == 1 or vim.fn.isdirectory(marker_path) == 1 then
        return current_dir
      end
    end
    -- Move up one directory
    local parent = vim.fn.fnamemodify(current_dir, ':h')
    if parent == current_dir then
      break
    end
    current_dir = parent
  end

  -- Fallback: use initial directory if no root found
  return initial_dir
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

  -- Get the appropriate shell command and arguments
  local shell_cmd, shell_args = get_shell_command()

  -- Prepare the command based on OS
  local cmd
  if is_windows then
    -- Windows: use 'cd /d' for changing drives
    project_root = normalize_path(project_root)
    if vim.fn.executable('pwsh') == 1 or vim.fn.executable('powershell') == 1 then
      cmd = string.format('%s %s -NoExit -Command "Set-Location \'%s\'"', 
        shell_cmd, table.concat(shell_args, ' '), project_root)
    else
      -- CMD.exe specific
      cmd = string.format('%s %s "cd /d %s"', 
        shell_cmd, table.concat(shell_args, ' '), project_root)
    end
  else
    -- Unix-like systems
    project_root = normalize_path(project_root)
    cmd = string.format('%s %s -c "cd \'%s\' && exec %s"', 
      shell_cmd, table.concat(shell_args, ' '), project_root, shell_cmd)
  end

  -- Set up error handling
  local ok, job = pcall(vim.fn.termopen, cmd, {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 and exit_code ~= 13 then
        vim.notify(string.format('Terminal exited with code: %d', exit_code), 
          vim.log.levels.WARN)
      end
      -- Close window when terminal exits
      pcall(vim.api.nvim_win_close, win, true)
    end,
    env = vim.tbl_extend('force', vim.fn.environ(), {
      -- Ensure proper terminal environment
      INSIDE_NEOVIM_TERMINAL = "1",
      TERM = os.getenv("TERM") or "xterm-256color"
    })
  })

  if not ok then
    vim.notify('Failed to open terminal: ' .. tostring(job), vim.log.levels.ERROR)
    pcall(vim.api.nvim_win_close, win, true)
    return
  end

  -- Enter terminal mode
  vim.cmd('startinsert')
end

--- Setup function for the plugin
function M.setup(opts)
  opts = opts or {}
  
  -- Create a user command to open the floating terminal
  vim.api.nvim_create_user_command('Terminal', M.open_floating_terminal, {})
  
  -- Set up the keymap for quick terminal access
  vim.keymap.set('n', '<leader>t', '<cmd>Terminal<cr>', { 
    desc = 'Open floating [T]erminal',
    silent = true 
  })
  
  -- Add terminal-specific keymaps
  vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
      -- Local terminal buffer mappings
      vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { 
        buffer = true, 
        desc = 'Exit terminal mode' 
      })
      
      -- Set terminal-specific options
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = 'no'
      
      -- Ensure proper terminal colors
      vim.opt_local.termguicolors = true
    end,
  })
end

return M
=======
--- Project Terminal Floating Window Plugin
local M = {}

-- Platform detection helper functions
local is_windows = vim.fn.has('win32') == 1
local is_wsl = vim.fn.has('wsl') == 1
local path_sep = is_windows and '\\' or '/'

--- Get the appropriate shell command and args for the current OS
---@return string shell The shell executable path
---@return string[] args The shell arguments
local function get_shell_command()
  if is_windows then
    -- Windows: Prefer PowerShell if available, fallback to cmd.exe
    if vim.fn.executable('pwsh') == 1 then
      return 'pwsh', {'-NoLogo'}
    elseif vim.fn.executable('powershell') == 1 then
      return 'powershell', {'-NoLogo'}
    else
      return vim.fn.exists('$COMSPEC') == 1 and vim.fn.expand('$COMSPEC') or 'cmd.exe', {'/k'}
    end
  elseif is_wsl then
    -- WSL: Use the default shell but ensure proper environment
    local shell = os.getenv('SHELL') or '/bin/bash'
    return shell, {'-l'}
  else
    -- Unix-like systems (Linux/macOS)
    local shell = os.getenv('SHELL') or '/bin/bash'
    return shell, {'-l'}
  end
end

--- Normalize path for current OS
---@param path string The path to normalize
---@return string normalized_path The normalized path
local function normalize_path(path)
  if is_windows then
    return path:gsub('/', '\\')
  else
    return path:gsub('\\', '/')
  end
end

--- Find the project root directory
---@return string The root directory of the project
local function find_project_root()
  -- Common project markers across all platforms
  local root_markers = {
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
    '.project',
  }

  -- Get the directory of the current buffer
  local current_dir = vim.fn.expand('%:p:h')
  local initial_dir = current_dir

  -- Traverse up the directory tree
  while current_dir ~= '' do
    for _, marker in ipairs(root_markers) do
      local marker_path = normalize_path(current_dir .. path_sep .. marker)
      if vim.fn.filereadable(marker_path) == 1 or vim.fn.isdirectory(marker_path) == 1 then
        return current_dir
      end
    end
    -- Move up one directory
    local parent = vim.fn.fnamemodify(current_dir, ':h')
    if parent == current_dir then
      break
    end
    current_dir = parent
  end

  -- Fallback: use initial directory if no root found
  return initial_dir
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

  -- Get the appropriate shell command and arguments
  local shell_cmd, shell_args = get_shell_command()

  -- Prepare the command based on OS
  local cmd
  if is_windows then
    -- Windows: use 'cd /d' for changing drives
    project_root = normalize_path(project_root)
    if vim.fn.executable('pwsh') == 1 or vim.fn.executable('powershell') == 1 then
      cmd = string.format('%s %s -NoExit -Command "Set-Location \'%s\'"', 
        shell_cmd, table.concat(shell_args, ' '), project_root)
    else
      -- CMD.exe specific
      cmd = string.format('%s %s "cd /d %s"', 
        shell_cmd, table.concat(shell_args, ' '), project_root)
    end
  else
    -- Unix-like systems
    project_root = normalize_path(project_root)
    cmd = string.format('%s %s -c "cd \'%s\' && exec %s"', 
      shell_cmd, table.concat(shell_args, ' '), project_root, shell_cmd)
  end

  -- Set up error handling
  local ok, job = pcall(vim.fn.termopen, cmd, {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 and exit_code ~= 13 then
        vim.notify(string.format('Terminal exited with code: %d', exit_code), 
          vim.log.levels.WARN)
      end
      -- Close window when terminal exits
      pcall(vim.api.nvim_win_close, win, true)
    end,
    env = vim.tbl_extend('force', vim.fn.environ(), {
      -- Ensure proper terminal environment
      INSIDE_NEOVIM_TERMINAL = "1",
      TERM = os.getenv("TERM") or "xterm-256color"
    })
  })

  if not ok then
    vim.notify('Failed to open terminal: ' .. tostring(job), vim.log.levels.ERROR)
    pcall(vim.api.nvim_win_close, win, true)
    return
  end

  -- Enter terminal mode
  vim.cmd('startinsert')
end

--- Setup function for the plugin
function M.setup(opts)
  opts = opts or {}
  
  -- Create a user command to open the floating terminal
  vim.api.nvim_create_user_command('Terminal', M.open_floating_terminal, {})
  
  -- Set up the keymap for quick terminal access
  vim.keymap.set('n', '<leader>t', '<cmd>Terminal<cr>', { 
    desc = 'Open floating [T]erminal',
    silent = true 
  })
  
  -- Add terminal-specific keymaps
  vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
      -- Local terminal buffer mappings
      vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { 
        buffer = true, 
        desc = 'Exit terminal mode' 
      })
      
      -- Set terminal-specific options
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = 'no'
      
      -- Ensure proper terminal colors
      vim.opt_local.termguicolors = true
    end,
  })
end

return M
>>>>>>> 2b6732b15169e89d5d80d3ad909fed770f9d2613
