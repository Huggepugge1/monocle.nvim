local M = {}

local cache = {
	project_name = "",
	branch_name = "",
	commit_count = 0,
	contributors = {},
	changes = { insertions = 0, deletions = 0 },
}

local function run_command_async(command, callback)
	vim.system(command, { text = true }, function(obj)
		if obj.code == 0 and obj.stdout and vim.trim(obj.stdout) ~= '' then
			pcall(callback, vim.trim(obj.stdout))
		end
	end)
end

local function git_command_async(args, callback)
	local command = { "git", unpack(args) }
	run_command_async(command, callback)
end

function M.start_polling()
	git_command_async({ "config", "--get", "remote.origin.url" }, function(path)
		if path == "" then
			path = vim.fn.getcwd()
		end
		run_command_async({ "basename", path }, function(name)
			if name:sub(-4) == ".git" then
				name = name:sub(1, -5)
			end
			cache.project_name = name
		end)
	end)

	git_command_async({ "branch", "--show-current" }, function(name)
		cache.branch_name = name
	end)

	git_command_async({ "rev-list", "HEAD", "--count" }, function(count)
		cache.branch_commit_count = tonumber(count) or 0
	end)

	git_command_async({ "rev-list", "--all", "--count" }, function(count)
		cache.repo_commit_count = tonumber(count) or 0
	end)

	git_command_async({ "log", "--all", "--pretty=format:%an" }, function(contributors)
		local lines = vim.split(contributors, '\n', { trimempty = true })
		local seen = {}
		local unique = {}
		for _, name in ipairs(lines) do
			if not seen[name] then
				seen[name] = true
				table.insert(unique, name)
			end
		end
		cache.contributors = unique
	end)

	git_command_async({ "diff", "--numstat" }, function(output)
		local insertions, deletions = 0, 0
		for _, line in ipairs(vim.split(output, '\n')) do
			local fields = vim.split(line, '\t')
			insertions = insertions + (tonumber(fields[1]) or 0)
			deletions = deletions + (tonumber(fields[2]) or 0)
		end
		cache.changes = { insertions = insertions, deletions = deletions }
	end)
end

function M.get_project_name()
	return cache.project_name or ""
end

function M.get_branch_name()
	return cache.branch_name or ""
end

function M.get_number_of_commits_in_branch()
	return cache.branch_commit_count or 0
end

function M.get_number_of_commits_in_repo()
	return cache.repo_commit_count or 0
end

function M.get_contributors()
	return cache.contributors or {}
end

function M.get_number_of_contributors()
	return #(cache.contributors or {})
end

function M.get_number_of_changes()
	return cache.changes or { insertions = 0, deletions = 0 }
end

return M
