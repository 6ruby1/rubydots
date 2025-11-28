-- INFO: Not managed by package manager!

local function setup()
	-- list of trailing-path fragments to sort by mtime
	local mtime_suffixes = {
		"Downloads",
		"Trash/files",
		"tmp",
		-- add more suffixes here
	}

	ps.sub("cd", function()
		local cwd = cx and cx.active and cx.active.current and cx.active.current.cwd
		if not cwd then
			return
		end

		for _, suffix in ipairs(mtime_suffixes) do
			if cwd:ends_with(suffix) then
				ya.emit("sort", { "mtime", reverse = true, dir_first = false })
				return
			end
		end

		ya.emit("sort", { "alphabetical", reverse = false, dir_first = true })
	end)
end

return { setup = setup }
