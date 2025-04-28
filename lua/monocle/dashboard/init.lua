local M = {}


local git = require('monocle.git')

function M.init()
	vim.api.nvim_create_user_command('MonocleDashboard', M.show_dashboard, {})
end

local function create_window(enter, win_config, lines)
	local buf = vim.api.nvim_create_buf(false, true)

	local win = vim.api.nvim_open_win(buf, enter, win_config)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	vim.bo[buf].modifiable = false
	vim.bo[buf].readonly = true
	vim.bo[buf].buftype = 'nofile'
	vim.bo[buf].bufhidden = 'wipe'
	vim.bo[buf].buflisted = false
	vim.bo[buf].swapfile = false

	return win
end

local function get_row_height(row_layout)
	local height = 0
	for _, col_layout in ipairs(row_layout) do
		height = math.max(#col_layout.lines, height)
	end
	return height
end

local function create_layout(layout)
	local windows = {}
	local basic_win_config = {
		relative = 'editor',
		style = 'minimal',
		border = 'rounded',
		title_pos = 'center',
		focusable = false,
		zindex = 2,
	}

	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.6)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local main_win_config = vim.tbl_deep_extend(
		'force', basic_win_config, {
			width = width,
			height = height,
			row = row,
			col = col,
			title = git.get_project_name(),
			zindex = 1,
		}
	)

	row = row + 1

	windows.main = create_window(true, main_win_config, {})

	for _, layout_row in ipairs(layout) do
		local row_height = get_row_height(layout_row)
		col = math.floor((vim.o.columns - width) / 2) + 2
		for _, layout_col in ipairs(layout_row) do
			local win_config = vim.tbl_deep_extend('force', basic_win_config, layout_col.win_config)
			local col_width = math.floor((width - 3 * #layout_row) / #layout_row)

			win_config = vim.tbl_deep_extend('force', win_config, {
				width = col_width,
				height = row_height,
				row = row,
				col = col,
				zindex = 2,
			})
			table.insert(windows, create_window(false, win_config, layout_col.lines))
			col = col + math.floor((width - 2 * #layout_row) / #layout_row) + 2
		end
		row = row + row_height + 2
	end

	return windows
end

function M.show_dashboard()
	local cursor = vim.opt.guicursor
	vim.opt.guicursor = 'a:Invisible'

	local layout = {
		{
			require('monocle.dashboard.commits').commit_stats(),
			require('monocle.dashboard.contributors').contributor_stats(),
		},
	}
	local windows = create_layout(layout)

	local function close_dashboard()
		vim.opt.guicursor = cursor
		for _, window in pairs(windows) do
			vim.api.nvim_win_close(window, true)
		end
	end

	vim.keymap.set('n', 'q', close_dashboard, { buffer = vim.api.nvim_get_current_buf() })
	vim.keymap.set('n', '<Esc>', close_dashboard, { buffer = vim.api.nvim_get_current_buf() })
end

return M
