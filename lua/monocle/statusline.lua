local M = {}
local git = require("monocle.git")

local function display_repo_name(config, sections)
	if config.name then
		sections.lualine_a = { { git.get_project_name } }
	end
end

local function display_branch(config, sections)
	if config.branch then
		sections.lualine_b = { { git.get_branch_name } }
	end
end

local function display_changes(config, sections)
	if config.changes then
		vim.api.nvim_set_hl(0, "MonocleAdded", { fg = "#00ff00", bold = true })
		vim.api.nvim_set_hl(0, "MonocleRemoved", { fg = "#ff0000", bold = true })

		sections.lualine_c = { {
			function()
				local changes = git.get_number_of_changes()
				return string.format(
					"[%%#MonocleAdded#+%d%%#Normal# %%#MonocleRemoved#-%d%%#Normal#]",
					changes.insertions,
					changes.deletions
				)
			end
		} }
	end
end

local function display_time(config, sections)
	local time_config = config.current_time or { enable = false }

	if time_config.enable then
		sections.lualine_z = { {
			function()
				local format = {}
				if time_config.hours then
					table.insert(format, "%H")
				end
				if time_config.minutes then
					table.insert(format, "%M")
				end
				if time_config.seconds then
					table.insert(format, "%S")
				end

				local format_string = ""
				for i, format_char in ipairs(format) do
					format_string = format_string .. format_char
					if format[i + 1] then
						format_string = format_string .. ':'
					end
				end
				return os.date(format_string)
			end
		} }
	end
end

function M.display_statusline(config)
	local statusline = config.statusline or {}

	local sections = {
		lualine_a = { {} },
		lualine_b = { {} },
		lualine_c = { {} },
		lualine_x = { {} },
		lualine_y = { "filename", "location", },
		lualine_z = { {} },
	}

	display_repo_name(statusline, sections)
	display_branch(statusline, sections)
	display_changes(statusline, sections)
	display_time(statusline, sections)

	require("lualine").setup {
		options = {
			component_separators = { left = ':', right = '-' },
			section_separators = { left = ' ', right = ' ' },
		},
		sections = sections,
		inactive_sections = sections,
	}
end

return M
