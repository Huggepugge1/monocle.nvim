local M = {}

function M.display_statusline(config)
	local git = require("monocle.git")

	local statusline = config.statusline or {}

	local statusline_sections = {
		lualine_a = { {} },
		lualine_b = { {} },
		lualine_c = { {} },
		lualine_x = { {} },
		lualine_y = { "filename", "location", },
		lualine_z = { {} },
	}

	vim.notify(vim.inspect(require('lualine').get_config()))

	if statusline.name then
		statusline_sections.lualine_a = { { git.get_project_name } }
	end

	if statusline.branch then
		statusline_sections.lualine_b = { { git.get_branch_name } }
	end

	if statusline.changes then
		vim.api.nvim_set_hl(0, "MonocleAdded", { fg = "#00ff00", bold = true })
		vim.api.nvim_set_hl(0, "MonocleRemoved", { fg = "#ff0000", bold = true })

		local changes = git.get_number_of_changes()
		statusline_sections.lualine_c = { {
			function()
				return string.format(
					"[%%#MonocleAdded#+%d%%#Normal# %%#MonocleRemoved#-%d%%#Normal#]",
					changes.insertions,
					changes.deletions
				)
			end
		} }
	end

	if statusline.number_of_commits then
		statusline_sections.lualine_x = { {
			function()
				local commits = git.get_number_of_commits_in_branch()
				return string.format("commits: %d", commits)
			end
		} }
	end

	if statusline.current_time then
		statusline_sections.lualine_z = { {
			'time'
		} }
	end

	require("lualine").setup {
		options = {
			component_separators = { left = ':', right = '-' },
			section_separators = { left = ' ', right = ' ' },
		},
		sections = statusline_sections,
	}
end

return M
