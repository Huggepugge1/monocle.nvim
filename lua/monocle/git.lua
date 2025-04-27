local M = {}

function M.get_repo_name()
	local path = vim.system(
		{ 'git', 'config', '--get', 'remote.origin.url' },
		{ text = true }
	):wait().stdout:gsub('\n', '') or ''

	if path == '' then
		-- Fallback to CWD
		path = vim.fn.getcwd()
	end

	local name = vim.system(
		{ 'basename', path },
		{ text = true }
	):wait().stdout:gsub('\n', '') or ''

	if string.sub(name, #name - 3, #name) == ".git" then
		name = string.sub(name, 1, #name - 4)
	end

	return name
end

return M
