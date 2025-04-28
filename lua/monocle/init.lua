local M = {}

M.config = {
	statusline = {
		name = true,
		branch = true,
		changes = true,
		number_of_commits = false,
		current_time = true,
	}
}

function M.reload()
	local modules = {
		"monocle.git",
		"monocle.statusline",
	}

	for _, module in ipairs(modules) do
		package.loaded[module] = nil
	end
end

function M.setup(user_config)
	local statusline = require("monocle.statusline")

	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

	statusline.display_statusline(M.config)
end

return M
