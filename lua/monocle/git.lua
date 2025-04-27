local M = {}

local function run_command(command)
	return vim.trim(
		vim.system(
			command,
			{ text = true }
		):wait().stdout or ''
	)
end

local function git_command(command --[[table]])
	command = { 'git', unpack(command) }
	return run_command(command)
end

function M.get_project_name()
	local path = git_command({ 'config', '--get', 'remote.origin.url' })

	if path == '' then
		-- Fallback to CWD
		path = vim.fn.getcwd()
	end

	local name = run_command({ 'basename', path })

	if string.sub(name, #name - 3, #name) == ".git" then
		name = string.sub(name, 1, #name - 4)
	end

	return name
end

function M.get_branch_name()
	return git_command({ 'branch', '--show-current' })
end

return M
