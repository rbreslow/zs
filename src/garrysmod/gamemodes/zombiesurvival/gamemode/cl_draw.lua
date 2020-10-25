local draw_SimpleText = draw.SimpleText
local draw_DrawText = draw.DrawText

local FontBlurX = 0
local FontBlurX2 = 0
local FontBlurY = 0
local FontBlurY2 = 0

timer.Create("fontblur", 0.1, 0, function()
	FontBlurX = math.random(-8, 8)
	FontBlurX2 = math.random(-8, 8)
	FontBlurY = math.random(-8, 8)
	FontBlurY2 = math.random(-8, 8)
end)

local color_blur1 = Color(60, 60, 60, 220)
local color_blur2 = Color(40, 40, 40, 140)
function draw.SimpleTextBlur(text, font, x, y, col, xalign, yalign)
	if GAMEMODE.FontEffects then
		color_blur1.a = col.a * 0.85
		color_blur2.a = col.a * 0.55
		draw_SimpleText(text, font, x + FontBlurX, y + FontBlurY, color_blur1, xalign, yalign)
		draw_SimpleText(text, font, x + FontBlurX2, y + FontBlurY2, color_blur2, xalign, yalign)
	end
	draw_SimpleText(text, font, x, y, col, xalign, yalign)
end

function draw.DrawTextBlur(text, font, x, y, col, xalign)
	if GAMEMODE.FontEffects then
		color_blur1.a = col.a * 0.85
		color_blur2.a = col.a * 0.55
		draw_DrawText(text, font, x + FontBlurX, y + FontBlurY, color_blur1, xalign)
		draw_DrawText(text, font, x + FontBlurX2, y + FontBlurY2, color_blur2, xalign)
	end
	draw_DrawText(text, font, x, y, col, xalign)
end

local colBlur = Color(0, 0, 0)
function draw.SimpleTextBlurry(text, font, x, y, col, xalign, yalign)
	if GAMEMODE.FontEffects then
		colBlur.r = col.r
		colBlur.g = col.g
		colBlur.b = col.b
		colBlur.a = col.a * math.Rand(0.35, 0.6)

		draw_SimpleText(text, font.."Blur", x, y, colBlur, xalign, yalign)
	end
	draw_SimpleText(text, font, x, y, col, xalign, yalign)
end

function draw.DrawTextBlurry(text, font, x, y, col, xalign)
	if GAMEMODE.FontEffects then
		colBlur.r = col.r
		colBlur.g = col.g
		colBlur.b = col.b
		colBlur.a = col.a * math.Rand(0.35, 0.6)

		draw_DrawText(text, font.."Blur", x, y, colBlur, xalign)
	end
	draw_DrawText(text, font, x, y, col, xalign)
end

local mat_white = Material("vgui/white")

function draw.SimpleLinearGradient(x, y, w, h, startColor, endColor, horizontal)
	draw.LinearGradient(x, y, w, h, { {offset = 0, color = startColor}, {offset = 1, color = endColor} }, horizontal)
end

--[[
The stops argument is a table of GradientStop structures.
Example:
	draw.LinearGradient(0, 0, 100, 100, {
		{offset = 0, color = Color(255, 0, 0)},
		{offset = 0.5, color = Color(255, 255, 0)},
		{offset = 1, color = Color(255, 0, 0)}
	}, false)
== GradientStop structure ==
Field  |  Type  | Description
------ | ------ | ---------------------------------------------------------------------------------------
offset | number | Where along the gradient should this stop occur, scaling from 0 (beginning) to 1 (end).
color  | table  | Color structure of what color this stop should be.
]]
function draw.LinearGradient(x, y, w, h, stops, horizontal)
	if #stops == 0 then
		return
	elseif #stops == 1 then
		surface.SetDrawColor(stops[1].color)
		surface.DrawRect(x, y, w, h)
		return
	end

	table.SortByMember(stops, "offset", true)

	render.SetMaterial(mat_white)
	mesh.Begin(MATERIAL_QUADS, #stops - 1)
	for i = 1, #stops - 1 do
		local offset1 = math.Clamp(stops[i].offset, 0, 1)
		local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
		if offset1 == offset2 then continue end

		local deltaX1, deltaY1, deltaX2, deltaY2

		local color1 = stops[i].color
		local color2 = stops[i + 1].color

		local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
		local r2, g2, b2, a2
		local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
		local r4, g4, b4, a4

		if horizontal then
			r2, g2, b2, a2 = r3, g3, b3, a3
			r4, g4, b4, a4 = r1, g1, b1, a1
			deltaX1 = offset1 * w
			deltaY1 = 0
			deltaX2 = offset2 * w
			deltaY2 = h
		else
			r2, g2, b2, a2 = r1, g1, b1, a1
			r4, g4, b4, a4 = r3, g3, b3, a3
			deltaX1 = 0
			deltaY1 = offset1 * h
			deltaX2 = w
			deltaY2 = offset2 * h
		end

		mesh.Color(r1, g1, b1, a1)
		mesh.Position(Vector(x + deltaX1, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r2, g2, b2, a2)
		mesh.Position(Vector(x + deltaX2, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r3, g3, b3, a3)
		mesh.Position(Vector(x + deltaX2, y + deltaY2))
		mesh.AdvanceVertex()

		mesh.Color(r4, g4, b4, a4)
		mesh.Position(Vector(x + deltaX1, y + deltaY2))
		mesh.AdvanceVertex()
	end
	mesh.End()
end
