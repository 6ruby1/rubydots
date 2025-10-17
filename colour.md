## Purple

#a48cf2
rgb(164,140,242)
hsl(254.12, 79.69%, 74.9%)
cmyk(32,42,0,5)
ANSI16 5
ANSI256 63

## Blue/cyan

#04d1f9
rgb(4, 209, 249)
hsl(189.8, 96.84%, 49.61%)
cmyk(98, 16, 0, 2)
ANSI16 14
ANSI256 81

## Green

#37f499
rgb(55, 244, 153)
hsl(151.11, 89.57%, 58.63%)
cmyk(40, 36, 0, 78)
ANSI16 10
ANSI256 120

## Red

#f16c75
rgb(241, 108, 117)
hsl(355.94, 82.61%, 68.43%)
cmyk(0,55,51,5)
ANSI16 9
ANSI256 203

## Orange

#f7c67f
rgb(247, 198, 127)
hsl(35.5, 88.24%, 73.33%)
cmyk(0, 20, 49, 3)
ANSI16 11
ANSI256 222

## Dark Purple

#7081d0
rgb(112, 129, 208)
hsl(229.38, 50.53%, 62.75%)
cmyk(46, 38, 0, 18)
ASNI16 4
ANSI256 105

## Pink

#f265b5
rgb(242, 101, 181)
hsl(325.96, 84.43%, 67.25%)
cmyk(0, 58, 25, 5)
ANSI16 13
ANSI256 205

## Yellow

#f1fc79
rgb(241, 252, 121)
hsl(65.04, 95.62%, 73.14%)
cmyk(4, 0, 52, 1)
ANSI16 11
ANSI256 227

## Background

#212337
rgb(33, 35, 55)
hsl(234.55, 25%, 17.25%)
cmyk(40, 36, 0, 78)
ANSI16 0
ANSI256 236

## Alt Background

#323449
rgb(50, 52, 73)
hsl(234.78, 18.7%, 24.12%)
cmyk(32, 42, 0, 5)
ANSI16 8
ANSI256 59

## White

#ebfafa
rgb(235, 250, 250)
hsl(180, 60%, 95.1%)
cmyk(6, 0, 0, 2)
ANSI16 15
ANSI256 231

# eldritch.nvim pallette

```lua
M.default = {
  none = "NONE",
  bg_dark = "#171928",
  bg = "#212337",
  bg_highlight = "#292e42",
  terminal_black = "#414868",
  fg = "#ebfafa",
  fg_dark = "#ABB4DA",
  fg_gutter = "#3b4261",
  fg_gutter_light = "#7081d0",
  dark3 = "#6473B7",
  comment = "#7081d0",
  dark5 = "#5866A2",
  bright_cyan = "#39DDFD",
  visual = "#76639e",
  bg_visual = "#76639e",
  cyan = "#04d1f9",
  dark_cyan = "#10A1BD",
  magenta = "#a48cf2",
  magenta2 = "#bf4f8e",
  magenta3 = "#722f55",
  pink = "#f265b5",
  purple = "#a48cf2",
  orange = "#f7c67f",
  yellow = "#f1fc79",
  dark_yellow = "#c0c95f",
  green = "#37f499",
  bright_green = "#00FA82",
  dark_green = "#33C57F",
  red = "#f16c75",
  bright_red = "#f0313e",
  git = { change = "#7081d0", add = "#37f499", delete = "#f16c75" },
  gitSigns = {
    add = "#37f499",
    change = "#7081d0",
    delete = "#f16c75",
  },
}
```

## interactive elditch.nvim lua utils

```lua
-- Interactive Lua color utility and palette picker with palette preview and result formatting

local M = {}

---@class Palette
M.default = {
	none = "NONE",
	bg_dark = "#171928",
	bg = "#212337",
	bg_highlight = "#292e42",
	terminal_black = "#414868",
	fg = "#ebfafa",
	fg_dark = "#ABB4DA",
	fg_gutter = "#3b4261",
	fg_gutter_light = "#7081d0",
	dark3 = "#6473B7",
	comment = "#7081d0",
	dark5 = "#5866A2",
	bright_cyan = "#39DDFD",
	visual = "#76639e",
	bg_visual = "#76639e",
	cyan = "#04d1f9",
	dark_cyan = "#10A1BD",
	magenta = "#a48cf2",
	magenta2 = "#bf4f8e",
	magenta3 = "#722f55",
	pink = "#f265b5",
	purple = "#a48cf2",
	orange = "#f7c67f",
	yellow = "#f1fc79",
	dark_yellow = "#c0c95f",
	green = "#37f499",
	bright_green = "#00FA82",
	dark_green = "#33C57F",
	red = "#f16c75",
	bright_red = "#f0313e",
	git = { change = "#7081d0", add = "#37f499", delete = "#f16c75" },
	gitSigns = {
		add = "#37f499",
		change = "#7081d0",
		delete = "#f16c75",
	},
}

M.bg = M.default.bg
M.fg = M.default.fg

---@param c string
local function hexToRgb(c)
	c = c:gsub("#", "")
	return { tonumber(c:sub(1, 2), 16), tonumber(c:sub(3, 4), 16), tonumber(c:sub(5, 6), 16) }
end

---@param hex string
local function get_palette_name(hex)
	local flat = flatten_palette(M.default)
	for name, value in pairs(flat) do
		if value == hex then
			return name
		end
	end
	return nil
end

---@param foreground string
---@param background string
---@param alpha number|string
function M.blend(foreground, background, alpha)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = hexToRgb(background)
	local fg = hexToRgb(foreground)

	local blendChannel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.darken(hex, amount, bg)
	return M.blend(hex, bg or M.bg, amount)
end

function M.lighten(hex, amount, fg)
	return M.blend(hex, fg or M.fg, amount)
end

function M.invert_color(color)
	local ok, hsluv = pcall(require, "eldritch.hsluv")
	if not ok then
		return "eldritch.hsluv module not found"
	end
	if color ~= "NONE" then
		local hsl = hsluv.hex_to_hsluv(color)
		hsl[3] = 100 - hsl[3]
		if hsl[3] < 40 then
			hsl[3] = hsl[3] + (100 - hsl[3]) * (M.day_brightness or 0.0)
		end
		return hsluv.hsluv_to_hex(hsl)
	end
	return color
end

-- Palette Picker
function flatten_palette(pal)
	local flat = {}
	for k, v in pairs(pal) do
		if type(v) == "table" then
			for subk, subv in pairs(v) do
				flat[k .. "." .. subk] = subv
			end
		else
			flat[k] = v
		end
	end
	return flat
end

local function show_color_preview(name, hex)
	if hex == "NONE" then
		print(string.format("     %-18s %-9s NONE (no color)", name, hex))
		return
	end
	local rgb = hexToRgb(hex)
	local preview = string.format("\27[48;2;%d;%d;%dm     \27[0m", rgb[1], rgb[2], rgb[3])
	print(string.format("%s %-18s %-9s", preview, name, hex))
end

local function print_palette_previews()
	local flat = flatten_palette(M.default)
	local keys = {}
	for k, _ in pairs(flat) do
		table.insert(keys, k)
	end
	table.sort(keys)
	print("\nPalette colors:")
	for _, name in ipairs(keys) do
		show_color_preview(name, flat[name])
	end
end

local function pick_palette_color()
	local flat = flatten_palette(M.default)
	local keys = {}
	for k, _ in pairs(flat) do
		table.insert(keys, k)
	end
	table.sort(keys)
	print("\nSelect a color by name (or press Enter to quit):")
	local sel = io.read()
	if sel == "" then
		return nil
	end
	local color = flat[sel]
	if color then
		print("\nPreview of selected color:")
		show_color_preview(sel, color)
		return color
	else
		print("Not found: " .. sel)
		return nil
	end
end

-- Interactive Prompt
local function prompt(msg)
	io.write(msg)
	return io.read()
end

local function show_menu()
	print("\nChoose a function to run:")
	print("1. Blend two colors")
	print("2. Darken a color")
	print("3. Lighten a color")
	print("4. Invert a color (needs eldritch.hsluv)")
	print("5. Pick a color from Palette")
	print("6. Exit")
	io.write("Enter choice: ")
end

-- Print result with original name and preview, operation, and result color/preview
local function print_result(orig_name, orig_hex, operation, result_hex)
	if orig_hex == "NONE" then
		show_color_preview(orig_name, orig_hex)
		print(string.format("Operation: %s", operation))
		print("Result: NONE (no color)")
		return
	end
	show_color_preview(orig_name, orig_hex)
	print(string.format("Operation: %s", operation))
	if result_hex and result_hex:sub(1, 1) == "#" then
		show_color_preview("result", result_hex)
	else
		print("Result: " .. tostring(result_hex))
	end
end

local function run()
	print_palette_previews()
	while true do
		show_menu()
		local choice = tonumber(io.read())
		if choice == 1 then
			local fg_input = prompt("Enter foreground color (hex or palette name): ")
			local fg = M.default[fg_input] or fg_input
			local fg_name = get_palette_name(fg) or fg_input
			local bg_input = prompt("Enter background color (hex or palette name): ")
			local bg = M.default[bg_input] or bg_input
			local bg_name = get_palette_name(bg) or bg_input
			local alpha = prompt("Enter alpha (0-1 or hex): ")
			local blend = M.blend(fg, bg, tonumber(alpha) or alpha)
			print_result(fg_name .. " (fg) | " .. bg_name .. " (bg)", fg, "blend", blend)
		elseif choice == 2 then
			local hex_input = prompt("Enter color (hex or palette name): ")
			local hex = M.default[hex_input] or hex_input
			local name = get_palette_name(hex) or hex_input
			local amount = tonumber(prompt("Enter amount (0-1): "))
			local bg_input = prompt("Enter background color (hex or palette name, optional): ")
			local bg = (bg_input ~= "" and (M.default[bg_input] or bg_input)) or nil
			local result = M.darken(hex, amount, bg)
			print_result(name, hex, "darken", result)
		elseif choice == 3 then
			local hex_input = prompt("Enter color (hex or palette name): ")
			local hex = M.default[hex_input] or hex_input
			local name = get_palette_name(hex) or hex_input
			local amount = tonumber(prompt("Enter amount (0-1): "))
			local fg_input = prompt("Enter foreground color (hex or palette name, optional): ")
			local fg = (fg_input ~= "" and (M.default[fg_input] or fg_input)) or nil
			local result = M.lighten(hex, amount, fg)
			print_result(name, hex, "lighten", result)
		elseif choice == 4 then
			local color_input = prompt("Enter color (hex or palette name): ")
			local color = M.default[color_input] or color_input
			local name = get_palette_name(color) or color_input
			local result = M.invert_color(color)
			print_result(name, color, "invert", result)
		elseif choice == 5 then
			pick_palette_color()
		elseif choice == 6 then
			print("Exiting.")
			break
		else
			print("Invalid choice.")
		end
	end
end

-- Run as script if executed directly
if pcall(debug.getlocal, 4, 1) == false then
	run()
end

return M
```

# Eldritch Syntax Highlighting Specification

1.  Prelude
    1.1 Color Palette
    1.1.1 Standard

        Background:
            #212337
        Current Line:
            #323449
        Foreground:
            #ebfafa
        Comment:
            #7081d0
        Cyan:
            #04d1f9
        Green:
            #37f499
        Orange:
            #f7c67f
        Pink:
            #f265b5
        Purple:
            #a48cf2
        Red:
            #f16c75
        Yellow:
            #f1fc79

1.1.2 ANSI

    AnsiBlack
        #21222C
    AnsiRed
        #f16c75
    AnsiGreen
        #37f499
    AnsiYellow
        #f1fc79
    AnsiBlue
        #a48cf2
    AnsiMagenta
        #f265b5
    AnsiCyan
        #04d1f9
    AnsiWhite
        #ebfafa
    AnsiBrightBlack
        #323449
    AnsiBrightRed
        #f9515d
    AnsiBrightGreen
        #69F8B3
    AnsiBrightYellow
        #e9f941
    AnsiBrightBlue
        #9071f4
    AnsiBrightMagenta
        #FD92CE
    AnsiBrightCyan
        #66e4fd
    AnsiBrightWhite
        #FFFFFF

2. Supplementary Colors

   bg_dark
   #171928
   bg_highlight
   #292e42
   terminal_black
   #414868
   fg_dark
   #ABB4DA
   fg_gutter
   #3b4261
   dark3
   #6473B7
   comment
   #7081d0
   dark5
   #5866A2
   visual
   #76639e
   dark_cyan
   #10A1BD
   magenta2
   #bf4f8e
   magenta3
   #722f55
   dark_yellow
   #c0c95f
   dark_green
   #33C57F
   bright_red
   #f0313e

3. Syntax Highlighting

   ["@error"] = { fg = colors.bright_red },
   ["@punctuation.delimiter"] = { fg = colors.fg },
   ["@punctuation.bracket"] = { fg = colors.fg },
   ["@markup.list"] = { fg = colors.cyan },
   ["@constant"] = { fg = colors.bright_cyan },
   ["@constant.builtin"] = { fg = colors.bright_cyan },
   ["@markup.link.label.symbol"] = { fg = colors.bright_cyan },
   ["@constant.macro"] = { fg = colors.cyan },
   ["@string.regexp"] = { fg = colors.yellow },
   ["@string"] = { fg = colors.yellow },
   ["@string.escape"] = { fg = colors.cyan },
   ["@string.special.symbol"] = { fg = colors.green },
   ["@character"] = { fg = colors.pink },
   ["@number"] = { fg = colors.green },
   ["@boolean"] = { fg = colors.green },
   ["@number.float"] = { fg = colors.pink },
   ["@annotation"] = { fg = colors.yellow },
   ["@attribute"] = { fg = colors.cyan },
   ["@module"] = { fg = colors.orange },
   ["@function.builtin"] = { fg = colors.cyan },
   ["@function"] = { fg = colors.purple },
   ["@function.macro"] = { fg = colors.purple },
   ["@variable.parameter"] = { fg = colors.orange },
   ["@variable.parameter.reference"] = { fg = colors.orange },
   ["@function.method"] = { fg = colors.purple },
   ["@variable.member"] = { fg = colors.orange },
   ["@property"] = { fg = colors.bright_green },
   ["@constructor"] = { fg = colors.cyan },
   ["@keyword.conditional"] = { fg = colors.purple },
   ["@keyword.repeat"] = { fg = colors.purple },
   ["@label"] = { fg = colors.cyan },
   ["@keyword"] = { fg = colors.green },
   ["@keyword.function"] = { fg = colors.cyan },
   ["@keyword.function.ruby"] = { fg = colors.purple },
   ["@keyword.operator"] = { fg = colors.purple },
   ["@operator"] = { fg = colors.purple },
   ["@keyword.exception"] = { fg = colors.green },
   ["@type"] = { fg = colors.bright_purple },
   ["@type.builtin"] = { fg = colors.cyan, italic = true },
   ["@type.qualifier"] = { fg = colors.purple },
   ["@type.def"] = { fg = colors.yellow },
   ["@structure"] = { fg = colors.green },
   ["@keyword.include"] = { fg = colors.purple },
   ["@variable"] = { fg = colors.red },
   ["@variable.builtin"] = { fg = colors.green },
   ["@markup"] = { fg = colors.orange },
   ["@markup.strong"] = { fg = colors.orange, bold = true }, -- bold
   ["@markup.emphasis"] = { fg = colors.yellow, italic = true }, -- italic
   ["@markup.underline"] = { fg = colors.orange },
   ["@markup.heading"] = { fg = colors.purple, bold = true }, -- title
   ["@markup.raw"] = { fg = colors.yellow }, -- inline code
   ["@markup.link.url"] = { fg = colors.yellow, italic = true }, -- urls
   ["@markup.link"] = { fg = colors.orange, bold = true },
   ["@tag"] = { fg = colors.cyan },
   ["@tag.attribute"] = { fg = colors.pink },
   ["@tag.delimiter"] = { fg = colors.cyan },

Semantic

    ["@class"] = { fg = colors.cyan },
    ["@struct"] = { fg = colors.cyan },
    ["@enum"] = { fg = colors.cyan },
    ["@enumMember"] = { fg = colors.green },
    ["@event"] = { fg = colors.cyan },
    ["@interface"] = { fg = colors.cyan },
    ["@modifier"] = { fg = colors.cyan },
    ["@regexp"] = { fg = colors.yellow },
    ["@typeParameter"] = { fg = colors.cyan },
    ["@decorator"] = { fg = colors.cyan },

LSP Semantic

    ["@lsp.type.boolean"] = { link = "@boolean" },
    ["@lsp.type.builtinType"] = { link = "@type.builtin" },
    ["@lsp.type.comment"] = { link = "@comment" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.deriveHelper"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.escapeSequence"] = { link = "@string.escape" },
    ["@lsp.type.formatSpecifier"] = { link = "@markup.list" },
    ["@lsp.type.generic"] = { link = "@variable" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.number"] = { link = "@number" },
    ["@lsp.type.operator"] = { link = "@operator" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
    ["@lsp.type.selfTypeKeyword"] = { link = "@variable.builtin" },
    ["@lsp.type.string"] = { link = "@string" },
    ["@lsp.type.typeAlias"] = { link = "@type.def" },
    ["@lsp.type.variable"] = {}, -- use treesitter styles for regular variables
    ["@lsp.typemod.class.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.enum.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.keyword.injected"] = { link = "@keyword" },
    ["@lsp.typemod.macro.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.operator.injected"] = { link = "@operator" },
    ["@lsp.typemod.string.injected"] = { link = "@string" },
    ["@lsp.typemod.struct.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.variable.callable"] = { link = "@function" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.injected"] = { link = "@variable" },
    ["@lsp.typemod.variable.static"] = { link = "@constant" },
    ["@lsp.type.namespace.python"] = { link = "@variable" },

HTML

    htmlArg = { fg = colors.pink },
    htmlBold = { fg = colors.yellow, bold = true },
    htmlEndTag = { fg = colors.cyan },
    htmlH1 = { fg = colors.purple },
    htmlH2 = { fg = colors.purple },
    htmlH3 = { fg = colors.purple },
    htmlH4 = { fg = colors.purple },
    htmlH5 = { fg = colors.purple },
    htmlH6 = { fg = colors.purple },
    htmlItalic = { fg = colors.green, italic = true },
    htmlLink = { fg = colors.green, underline = true },
    htmlSpecialChar = { fg = colors.yellow },
    htmlSpecialTagName = { fg = colors.cyan },
    htmlTag = { fg = colors.cyan },
    htmlTagN = { fg = colors.cyan },
    htmlTagName = { fg = colors.cyan },
    htmlTitle = { fg = colors.white },

Markdown

    markdownBlockquote = { fg = colors.yellow, italic = true },
    markdownBold = { fg = colors.orange, bold = true },
    markdownCode = { fg = colors.pink },
    markdownCodeBlock = { fg = colors.orange },
    markdownCodeDelimiter = { fg = colors.red },
    markdownH1 = { fg = colors.purple, bold = true },
    markdownH2 = { fg = colors.purple, bold = true },
    markdownH3 = { fg = colors.purple, bold = true },
    markdownH4 = { fg = colors.purple, bold = true },
    markdownH5 = { fg = colors.purple, bold = true },
    markdownH6 = { fg = colors.purple, bold = true },
    markdownHeadingDelimiter = { fg = colors.red },
    markdownHeadingRule = { fg = colors.comment },
    markdownId = { fg = colors.green },
    markdownIdDeclaration = { fg = colors.cyan },
    markdownIdDelimiter = { fg = colors.green },
    markdownItalic = { fg = colors.yellow, italic = true },
    markdownLinkDelimiter = { fg = colors.green },
    markdownLinkText = { fg = colors.purple },
    markdownListMarker = { fg = colors.cyan },
    markdownOrderedListMarker = { fg = colors.red },
    markdownRule = { fg = colors.comment },

Diff

    diffAdded = { fg = colors.pink },
    diffRemoved = { fg = colors.red },
    diffFileId = { fg = colors.yellow, bold = true, reverse = true },
    diffFile = { fg = colors.nontext },
    diffNewFile = { fg = colors.pink },
    diffOldFile = { fg = colors.red },
