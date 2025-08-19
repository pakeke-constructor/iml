
--[[

A tiny wee element-library for iml.

You should copy-paste these functions, and change the internal structure
to match your games theme.

(This file mainly serves to showcase *how* you should be using iml.)

]]

local iml = require("iml")


local elems = {}



function elems.newWindow(x,y, w,h)
    local window = {}
    local uniqueKey = {}

    function window:draw(ww,hh)
        love.graphics.setColor(0.8,0.8,1)
        love.graphics.rectangle("fill", x,y,w,h)
        w,h=ww or w,hh or h

        local dx,dy = iml.consumeDrag(uniqueKey, x,y,w,h, 1)
        if dx then
            x = x + dx
            y = y + dy
        end
    end

    return window
end



function elems.button(x,y,w,h)
    love.graphics.setColor(1,1,1)
    if iml.isHovered(x,y,w,h) then
        love.graphics.setColor(0.6,0.6,0.6)
    end
    love.graphics.rectangle("fill", x,y,w,h, h/10, h/10)
    if iml.wasJustClicked(x,y,w,h) then
        return true
    end
end



function elems.textInput(x,y,w,h, text)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", x,y,w,h)

    text = text or ""
    local newText = text
    if iml.isSelected(x,y,w,h) then
        newText = text .. (iml.consumeText() or "")
        local t = love.timer.getTime()
        if (math.floor(t*3) % 2) == 0 then
            love.graphics.setColor(0.2,0.2,0.2)
            love.graphics.rectangle("fill", x+w - 12, y+2, 10, h-4)
        end
    end

    local font = love.graphics.getFont()
    font:getWidth(newText)

    love.graphics.setStencilMode("draw", 1)
    love.graphics.rectangle("fill",x,y,w,h)
    love.graphics.setStencilMode("test", 1)

    love.graphics.setColor(0.2,0.3,0.3)
    love.graphics.printf(text, x,y, w, "left")

    love.graphics.setStencilMode("off")

    local wasChanged = newText~=text
    return wasChanged, newText
end




---@param slider {table:table, key:string, max:number, min:number}
---@param x any
---@param y any
---@param w any
---@param h any
function elems.slider(slider, x,y,w,h, id)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", x,y,w,h)
    id = id or ("#SLIDER_" .. slider.key)

    local min,max = slider.min,slider.max

    local delta = max-min
    local currentVal = slider.table[slider.key]
    local normalized = (currentVal - min) / delta

    local cx,cy, r = x + normalized*w, y+h/2, h/2
    love.graphics.setColor(0.3,0.6,0.9)
    love.graphics.circle("fill", cx, cy, r)

    local dx,_,cl = iml.consumeDrag(id, cx-r*1.5,cy-r*1.5, r*3,r*3, 1)
    if dx and cl then
        local change = dx / w
        local newVal = currentVal + (change * delta)
        slider.table[slider.key] = math.min(math.max(newVal, min), max)
    end
end





return elems
