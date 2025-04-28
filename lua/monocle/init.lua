local M = {}

M.config = {
	statusline = {
		name = true,
		branch = true,
		changes = true,
		current_time = {
			enable = true,
			hours = true,
			minutes = true,
			seconds = true,
		}
	}
}

function M.reload()
	local modules = {
		"monocle",
		"monocle.git",
		"monocle.statusline",
		"monocle.dashboard",
		"monocle.dashboard.commits",
		"monocle.dashboard.contributors",
	}

	for _, module in ipairs(modules) do
		package.loaded[module] = nil
	end
end

function M.setup(user_config)
	require('monocle.git').start_polling()
	vim.loop.new_timer():start(0, 5000, vim.schedule_wrap(function()
		require("monocle.git").start_polling() -- Re-run polling
	end))
	local statusline = require("monocle.statusline")
	local dashboard = require("monocle.dashboard")

	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

	statusline.display_statusline(M.config)
	dashboard.init()
end

return M
