

local iml = {}



---@alias iml._Panel {x:number, y:number, w:number,h:number, key:any}
---@alias iml._FrameState { topPanel: iml._Panel? }
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



---@param cl iml._Click
---@return boolean
local function isClick(cl)
    -- if it moves less than X distance, its a click
    return math.sqrt(cl.dx*cl.dx + cl.dy*cl.dy) > CLICK_MOVE_THRESHOLD
end


---@param x number
---@param y number
---@param w number
---@param h number
---@param px number
---@param py number
---@return boolean
local function isInside(x, y, w, h, px, py)
  return
    px > x and
    py > y and
    px < x + w and
    py < y + h
end



--- Creates a "Panel".
--- Mouse click / mouse hover won't propagate through this region.
---@param x number
---@param y number
---@param w number
---@param h number
---@param key any?
function iml.panel(x,y,w,h, key)
    -- If no key is specified,
    -- uses hash(x,y,w,h) as a key.
    if pointer_x and isInside(x,y,w,h, pointer_x, pointer_y) then
        frameState.topPanel = {
            x=x,y=y, w=w,h=h,
            key = getKey(x,y,w,h,key)
        }
    end
end


local function isTop(key)
    local tp = frameState and frameState.topPanel
    if tp and tp.key == key then
        return true
    end
    return false
end

--- Returns true if the region is currently being clicked.
--- (Called continously every frame whilst the mouse is down)
---@param x number
---@param y number
---@param w number
---@param h number
---@param button any
---@param keyy any
---@return boolean
function iml.isClicked(x,y,w,h, button, keyy)
    iml.panel(x,y,w,h, keyy)
    keyy = getKey(x,y,w,h,keyy)
    button = button or 1
    if isTop(keyy) then
    end
end


---@param x number
---@param y number
---@param w number
---@param h number
---@param key any
---@return boolean
function iml.isHovered(x,y,w,h, key)
    iml.panel(x,y,w,h, key)
    key = getKey(x,y,w,h,key)
    if isTop(key) then
        return true
    end
    return false
end



--- Returns true ONCE if the region was just clicked.
--- (ie ONLY the frame after `mousereleased`.)
function iml.wasJustClicked(x,y,w,h, button, keyy)
    keyy = getKey(x,y,w,h,keyy)
    button = button or 1
    error("nyi")
end


function iml.getDrag(x,y,w,h)

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
end




function iml.mousereleased(x, y, button, istouch, presses)
    local cl = clicks[button]
    clicks[button] = nil
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

