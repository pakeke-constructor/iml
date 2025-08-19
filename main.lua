

local iml = require("iml")

local elems = require("elems")


love.keyboard.setTextInput(true)

local settings = {
    -- range [0,100]% 
    sfx_volume = 50,
    music_volume = 30
}


local function newWindow(x,y, w,h)
    local window = {}
    local uniqueKey = {}

    function window:draw(ww,hh)
        love.graphics.setColor(0.8,0.8,1)
        love.graphics.rectangle("fill", x,y,w,h)
        w, h = ww or w, hh or h

        local dx,dy = iml.consumeDrag(uniqueKey, x,y,w,h, 1)
        if dx then
            x = x + dx
            y = y + dy
        end
    end

    return window
end


local function doButton(x,y,w,h)
    love.graphics.setColor(1,1,1)
    if iml.isHovered(x,y,w,h) then
        love.graphics.setColor(0.6,0.6,0.6)
    end
    love.graphics.rectangle("fill", x,y,w,h, h/10, h/10)
    if iml.wasJustClicked(x,y,w,h) then
        return true
    end
end



local w = newWindow(30,30,50,50)


function love.update()
    iml.setPointer(love.mouse.getPosition())
end

local tx = "h"

function love.draw()
    iml.beginFrame()

    if elems.button(10,10,70,30) then
        print("butto left")
    end

    if elems.button(130,10,70,30) then
        print("butto right")
    end

    local _
    _, tx = elems.textInput(360,60,200,20, tx)

    elems.slider({table=settings, key="sfx_volume", min=0,max=100}, 20,100, 200, 30)
    elems.slider({table=settings, key="sfx_volume", min=0,max=100}, 20,140, 200, 30)

    w:draw()

    iml.endFrame()
end


function love.mousepressed(x, y, button, istouch, presses)
    iml.mousepressed(x, y, button, istouch, presses)
end


function love.mousereleased(x, y, button, istouch, presses)
    iml.mousereleased(x, y, button, istouch, presses)
end


function love.textinput(txt)
    iml.textinput(txt)
end


function love.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode, isrepeat)

end


function love.wheelmoved(dx,dy)

end





