local M = {}

local git = require('monocle.git')

function M.contributor_stats()
	local win_config = {
		title = 'Contributors',
	}
	local lines = {
		'Contributors: ' .. git.get_number_of_contributors(),
	}

	for _, contributor in ipairs(git.get_contributors()) do
		table.insert(lines, contributor)
	end

	return {
		win_config = win_config,
		lines = lines
	}
end

return M
