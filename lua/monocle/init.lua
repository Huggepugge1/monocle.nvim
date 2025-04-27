local M = {}

M.config = {}

function M.reload()
	local modules = {
		'monocle.git',
	}

	for _, module in ipairs(modules) do
		package.loaded[module] = nil
	end
end

function M.setup(user_config)
	M.config = vim.tbl_deep_extend('force', M.config, user_config or {})

	local git = require('monocle.git')
	vim.notify(git.get_project_name())
	vim.notify(git.get_branch_name())
	vim.notify(tostring(git.get_number_of_commits_in_branch()))
end

return M
