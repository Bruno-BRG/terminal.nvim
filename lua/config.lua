-- Default configuration for terminal plugin
return {
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