local util = require('tokyonight.util')

local M = {}

function M.generate(colors)
	return util.template(
		[==[

[color]
red = '${red}'
red1 = '${red1}'
orange = '${orange}'
yellow = '${yellow}'
green = '${green}'
green1 = '${green1}'
green2 = '${green2}'
blue = '${blue}'
blue0 = '${blue0}'
blue1 = '${blue1}'
blue2 = '${blue2}'
blue5 = '${blue5}'
blue6 = '${blue6}'
blue7 = '${blue7}'
purple = '${purple}'
magenta = '${magenta}'
magenta2 = '${magenta2}'
cyan = '${cyan}'
black = '${black}'
white = '${fg}'
dark = '${fg_dark}'
dark3 = '${dark3}'
dark5 = '${dark5}'
teal = '${teal}'

[status]
success = '${green1}'
warning = '${warning}'
error = '${error}'

[log]
info = '${info}'
warn = '${warning}'
error = '${error}'

[fg]
primary = '${fg}'
dark = '${fg_dark}'
highlight = '${fg_gutter}'
visual = '${fg_visual}'

[bg]
primary = '${bg}'
dark = '${bg_dark}'
highlight = '${bg_highlight}'
visual = '${bg_visual}'

[border]
primary = '${fg_gutter}'
active = '${blue}'
inactive = '${bg_highlight}'

		]==],
		colors
	)
end

return M
