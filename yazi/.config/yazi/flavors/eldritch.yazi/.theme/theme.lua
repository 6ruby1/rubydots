-- comment.line.double-dash
--[[
comment.block
]]
PI = 3.14 -- constant.numeric
ESC = "\n" -- constant.character.escape
FLAG = true -- constant.language

-- @param c string
function myFunction(param) -- entity.name.function, variable.parameter
	local color = "#ff0000" -- constant.other, string.quoted.double
	if not FLAG then -- keyword.control
		return color -- keyword.control
	end
end

MyClass = {} -- entity.name.type
