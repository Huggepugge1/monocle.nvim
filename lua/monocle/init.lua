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
			seconds = false,
		}
	}
}

function M.reload()
	local modules = {
		"monocle.git",
		"monocle.statusline",
		"monocle.dashboard",
	}

	for _, module in ipairs(modules) do
		package.loaded[module] = nil
	end
end

function M.setup(user_config)
	local statusline = require("monocle.statusline")
	local dashboard = require("monocle.dashboard")

	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

	statusline.display_statusline(M.config)
	dashboard.init()
end

return M
