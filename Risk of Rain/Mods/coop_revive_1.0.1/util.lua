function point_distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function point_direction(x1, y1, x2, y2)
	return math.deg(math.atan2(y2 - y1, x2 - x1))
end

function lengthdir_x(len, dir)
	return len * math.cos(math.rad(dir))
end

function lengthdir_y(len, dir)
	return len * math.sin(math.rad(dir))
end

function print_color_ext(text, x, y, font, halign, valign)
	local text_formatted = text:gsub("&[%a%p%C]&", "")
	local xoffset = 0
	if halign == graphics.ALIGN_MIDDLE then xoffset = graphics.textWidth(text_formatted, font) / 2 end
	if halign == graphics.ALIGN_RIGHT then xoffset = graphics.textWidth(text_formatted, font) end
	local yoffset = 0
	if valign == graphics.ALIGN_CENTER or valign == graphics.ALIGN_CENTRE then yoffset = graphics.textHeight(text_formatted, font) / 2 end
	if valign == graphics.ALIGN_BOTTOM then yoffset = graphics.textHeight(text_formatted, font) end
    graphics.printColor(text, x - xoffset, y - yoffset, font)
end

function ternary(expression, iftrue, iffalse)
	if expression then return iftrue
	else return iffalse end
end