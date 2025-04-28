# monocle.nvim
**monocle.nvim** is a Neovim plugin designed to display key project statistics, including Git-related details, directly in the statusline and in a floating dashboard.
The plugin integrates seamlessly with Git and provides a clean, organized way to monitor your project’s activity.

## Features

- **Configurable Statusline**:
  - Displays **Repository Name** and **Branch**.
  - Displays the changes (lines added/removed) since the last commit.
  - Displays the current file and the cursor position.
  - Displays the current time.
  - Configurable to display only the important details.

- **Floating Dashboard for Project Stats**:
  - Displays key stats about the project in a floating window:
    - **Commits in Current Branch**
    - **Total Number of Commits in the Repository**
    - **Total Number of Contributors**
    - **List view of all the contributors**

## Setup
1. **Install monocle.nvim**:
### packer.nvim
```lua
use {
    'Huggepugge1/monocle.nvim',
    requires = { 'nvim-lualine/lualine.nvim' },
}
```
### lazy.nvim
```lua
{
    'Huggepugge1/monocle.nvim',
    dependencies = { 'nvim-lualine/lualine.nvim' },
}
```

### vim-plug
```lua
Plug 'Huggepugge1/monocle.nvim'
Plug 'nvim-lualine/lualine.nvim'
```

## Configuration
This is the default configuration
```lua
config = {
	statusline = {
        name = true,         -- Show repository name in the statusline
        branch = true,       -- Show current branch name in the statusline
        changes = true,      -- Show changes (insertions/deletions) in the statusline
        current_time = {     -- Show the current time in the statusline
            enable = true,     -- Enable time display
            hours = true,      -- Show hours
            minutes = true,    -- Show minutes
            seconds = false,   -- Don't show seconds
        }
	}
}
```

### Examples
```lua
require('monocle').setup()
```
```lua
-- Will not display repo name
require('monocle').setup({
    name = false,
})
```

## Displaying the Dashboard
**monocle.nvim** comes with the command ':MonocleDashboard'.
Execute it and the dashboard will open.
Close it with `q` or `<Esc>`.

## Plans
- **LOC** Lines of Code: Track the total number of lines of code in the repository
- **Time Logging**: Track the time you spent on each project

## Contributing
- Report issues or bugs
- Suggest improvements or new features
- Submit code for bug fixes or new fetaures via pull requests
