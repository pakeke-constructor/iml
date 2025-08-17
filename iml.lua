

local iml = {}



---@alias iml._Widget {x:number, y:number, w:number,h:number}
---@alias iml._FrameState { state: table<number, table>, clickables: iml._Widget[] }
---@alias iml._Click {x:number, y:number, dx:number,dy:number}


---@type iml._FrameState
local frameState = nil



local CLICK_MOVE_THRESHOLD = 4
-- less than 4 pixels = click
-- MORE than 4 pixels, drag



local clicks = {--[[
    [1] -> {x=x, y=y, dx=dx,dy=dy},
    [2] -> {x=x, y=y, dx=dx,dy=dy},
    [3] -> ...
]]}

local pointer_x = 0
local pointer_y = 0



function iml.beginFrame()
    frameState = {
        topPanel = nil
    }
end


local DOUBLE_MAX_PRECISION = 53 -- 2^53 is biggest double int precision
local ZEROS = math.floor(DOUBLE_MAX_PRECISION/4)

local function hash(x,y,w,h)
    return x
        + y*(2^ZEROS)
        + w*(2^(ZEROS*2))
        + h*(2^ZEROS*3)
end


local function getKey(x,y,w,h, key)
    return key or hash(x,y,w,h)
end



---@param key any
---@param x number
---@param y number
---@param w number
---@param h number
---@param value any
function iml.setState(key, x,y,w,h, value)
    local hh = hash(x,y,w,h)
    local obj = frameState.state[hh] or {}
    frameState.state[hh] = obj
    obj[key] = value
end


---@param key any
---@param x number
---@param y number
---@param w number
---@param h number
---@return any?
function iml.getState(key, x,y,w,h)
    local hh = hash(x,y,w,h)
    local obj = frameState.state[hh]
    if obj then
        return obj[key]
    end
end


function iml.isClicked(x,y,w,h, button, keyy)
    -- internally, uses hash(x,y,w,h) as a hash.
    keyy = keyy or hash(x,y,w,h)
    button = button or 1
end


function iml.getDrag(x,y,w,h)

end


function iml.isHovered(x,y,w,h)

end


function iml.endFrame()

end


--[[

==========================
EVENT CALL ORDER:
==========================


iml.beginFrame()
    local bool = iml.isClicked(x,y,w,h)
img.endFrame()


iml.mousepressed(...)

iml.mousereleased(...)

iml.keypressed(...)
iml.keyreleased(...)

]]


function iml.mousepressed(x, y, button, istouch, presses)
    -- "when mouse is pressed, store the widget that was pressed."
    if not frameState then return end

    for _, c in ipairs(frameState.clickables) do
        
    end
end


---@param cl iml._Click
---@return boolean
local function isClick(cl)
    -- if it moves less than X distance, its a click
    return math.sqrt(cl.dx*cl.dx + cl.dy*cl.dy) > CLICK_MOVE_THRESHOLD
end


---@param w iml._Widget
---@param x number
---@param y number
---@return boolean
local function isInside(w, x,y)
  return
    x >= w.x and
    y >= w.y and
    x <= w.x+w.w and
    y <= w.y+w.h
end


local EMPTY = {}


---@param lis 
---@param x any
---@param y any
local function findTop(lis, x,y)
    local arr = frameState.clickables or EMPTY
    for i=#arr, 1, -1 do
        local widget = arr[i]
        if isInside(widget, x,y) then

            return
        end
    end
end

function iml.mousereleased(x, y, button, istouch, presses)
    local cl = clicks[button]
    clicks[button] = nil
    if not cl then return end

    if isClick(cl) then
    else
        -- its not a click: its a drag!

    end
end


function iml.keypressed(key, scancode, isrepeat)
    if not frameState then return end
end

function iml.keyreleased(key, scancode, isrepeat)
    if not frameState then return end

end

function iml.setPointer(x,y)
    pointer_x = x
    pointer_y = y
end



return iml

