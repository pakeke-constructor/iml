

local iml = require("iml")


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


function love.update()
    iml.setPointer(love.mouse.getPosition())
end

function love.draw()
    iml.beginFrame()

    if doButton(10,10,70,30) then
        print("butto left")
    end

    if doButton(130,10,70,30) then
        print("butto right")
    end

    iml.endFrame()
end


function love.mousepressed(x, y, button, istouch, presses)
    iml.mousepressed(x, y, button, istouch, presses)
end


function love.mousereleased(x, y, button, istouch, presses)
    iml.mousereleased(x, y, button, istouch, presses)
end


function love.keypressed(key, scancode, isrepeat)

end

function love.keyreleased(key, scancode, isrepeat)

end


function love.wheelmoved(dx,dy)

end





