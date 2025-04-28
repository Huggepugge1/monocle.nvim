local M = {}

M.config = {
	statusline = {
		name = true,
		branch = true,
		changes = true
	}
}

function M.reload()
	local modules = {
		"monocle.git",
	}

	for _, module in ipairs(modules) do
		package.loaded[module] = nil
	end
end

function M.setup(user_config)
	local git = require("monocle.git")

	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

	local statusline = M.config.statusline or {}

	local statusline_sections = {
		lualine_a = { {} },
		lualine_b = { {} },
		lualine_c = { {} },
	}

	if statusline.name then
		statusline_sections.lualine_a = { { git.get_project_name } }
	end
	if statusline.branch then
		statusline_sections.lualine_b = { { git.get_branch_name } }
	end
	if statusline.changes then
		statusline_sections.lualine_c = { { git.get_number_of_changes } }
	end

	require("lualine").setup {
		sections = statusline_sections
	}
end

return M
