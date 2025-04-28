local M = {}

local git = require('monocle.git')

function M.init()
	vim.api.nvim_create_user_command('MonocleDashboard', M.show_dashboard, {})
end

function M.show_dashboard()
	local buf = vim.api.nvim_create_buf(false, false)
	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.6)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win_config = {
		relative = 'editor',
		width = width,
		height = height,
		row = row,
		col = col,
		style = 'minimal',
		border = 'rounded',
		title = git.get_project_name(),
		title_pos = 'center',
	}

	local win = vim.api.nvim_open_win(buf, true, win_config)

	local lines = {
		'Commits in ' .. git.get_branch_name() .. ': ' .. git.get_number_of_commits_in_branch(),
		'Commits in repo: ' .. git.get_number_of_commits_in_repo(),
	}

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	vim.bo[buf].modifiable = false
	vim.bo[buf].readonly = true
	vim.bo[buf].buftype = 'nofile'
	vim.bo[buf].bufhidden = 'wipe'
	vim.bo[buf].swapfile = false

	vim.keymap.set('n', 'q', function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf })

	vim.keymap.set('n', '<Esc>', function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf })
end

return M
