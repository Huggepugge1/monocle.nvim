local M = {}

local git = require('monocle.git')

function M.init()
	vim.api.nvim_create_user_command('MonocleDashboard', M.show_dashboard, {})
end

local function header(buf)
	local top_line = '┌' .. string.rep('─', buf.width - 2) .. '┐'
	local bottom_line = '└' .. string.rep('─', buf.width - 2) .. '┘'

	local spaces = '│' .. string.rep(' ', buf.width - 2) .. '│'

	local name = git.get_project_name()
	local header_name = '│' ..
		string.rep(' ', (buf.width - 2 - #name) / 2) ..
		name ..
		string.rep(' ', (buf.width - 2 - #name) / 2) ..
		'│'

	return { top_line, spaces, header_name, spaces, bottom_line }
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
	}

	local win = vim.api.nvim_open_win(buf, true, win_config)

	local lines = {
		unpack(header(win_config))
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
