local M = {}

local git = require('monocle.git')

function M.commit_stats()
	local win_config = {
		title = 'Commits',
	}
	local lines = {
		'Commits In Current Branch: ' .. git.get_number_of_commits_in_branch(),
		'Total Number Of Commits: ' .. git.get_number_of_commits_in_repo(),
	}

	return {
		win_config = win_config,
		lines = lines
	}
end

return M
