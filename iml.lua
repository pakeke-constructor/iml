

local iml = {}



---@alias iml._Panel {x:number, y:number, w:number,h:number, key:any}
---@alias iml._FrameState { topPanel: iml._Panel? }

---@alias iml._Click {original_x:number, original_y:number, total_dx:number,total_dy:number, last_frame_dx:number,last_frame_dy:number, panel_key:iml._Panel? }


---@type iml._Panel?
local lastTopPanel = nil

local frameCount = 0

---@type iml._FrameState
local frameState = nil



local CLICK_MOVE_THRESHOLD = 4
-- Click and move less than 4 pixels = click
-- MORE than 4 pixels, drag


-- tracks the "current" clicks.
-- (eg if user is holding down the mouse)
local currentClicks = {--[[
    [button] -> iml._Click
]]}



-- tracks the click-releases from the previous frame
local clickReleases = {--[[
    [button] = iml._Click
]]}


-- tracks the click-presses from the previous frame
local clickPresses = {--[[
    [button] = iml._Click
]]}



local pointer_x = 0
local pointer_y = 0

local last_pointer_x = 0
local last_pointer_y = 0


---@param cl iml._Click
---@return boolean
local function isClick(cl)
    -- if it moves less than X distance, its a click
    return math.sqrt(cl.total_dx*cl.total_dx + cl.total_dy*cl.total_dy) < CLICK_MOVE_THRESHOLD
end



local function assertIsFrame()
    if not frameState then
        error("No framestate was set! (Did you forget to call .beginFrame()..?)", 3)
    end
end


function iml.beginFrame()
    local px, py = pointer_x, pointer_y
    local pdx, pdy = pointer_x-last_pointer_x, pointer_y-last_pointer_y

    last_pointer_x = pointer_x
    last_pointer_y = pointer_y

    for _, cl in pairs(currentClicks) do
        cl.total_dx = px - cl.original_x
        cl.total_dy = py - cl.original_y

        cl.last_frame_dx = pdx
        cl.last_frame_dy = pdy
    end

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



---@param x number
---@param y number
---@param w number
---@param h number
---@param px number
---@param py number
---@return boolean
local function isInside(x, y, w, h, px, py)
  return
    px >= x and
    py >= y and
    px <= x + w and
    py <= y + h
end



--- Creates a "Panel".
--- Mouse click / mouse hover won't propagate through this region.
---@param x number
---@param y number
---@param w number
---@param h number
---@param key any?
function iml.panel(x,y,w,h, key)
    assertIsFrame()
    -- If no key is specified,
    -- uses hash(x,y,w,h) as a key.
    if pointer_x and isInside(x,y,w,h, pointer_x, pointer_y) then
        frameState.topPanel = {
            x=x,y=y, w=w,h=h,
            key = getKey(x,y,w,h,key)
        }
    end
end


function iml.pushMask(x,y,w,h)

end


function iml.popMask()

end


local function wasTop(key)
    -- returns whether this `key` was the top panel the previous frame
    if lastTopPanel and lastTopPanel.key == key then
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
    assertIsFrame()
    iml.panel(x,y,w,h, keyy)
    button = button or 1
    local cl = currentClicks[button]
    if cl and isClick(cl) then
        keyy = getKey(x,y,w,h,keyy)
        return wasTop(keyy)
    end
    return false
end


---@param x number
---@param y number
---@param w number
---@param h number
---@param key any
---@return boolean
function iml.isHovered(x,y,w,h, key)
    assertIsFrame()
    iml.panel(x,y,w,h, key)
    key = getKey(x,y,w,h,key)
    return wasTop(key)
end



--- Returns true ONCE if the region was just clicked.
--- (ie ONLY the frame after `mousereleased`.)
function iml.wasJustClicked(x,y,w,h, button, key)
    assertIsFrame()
    iml.panel(x,y,w,h, key)
    button = button or 1
    local cl = clickReleases[button]
    if cl and isClick(cl) then
        key = getKey(x,y,w,h,key)
        if wasTop(key) then
            return true
        end
    end
    return false
end


---@param key any
---@param button integer
function iml.getDrag(key, x,y,w,h, button)
    assertIsFrame()
    iml.panel(x,y,w,h, key)
    assert(key ~= nil and type(key) ~= "number", "Must provide a valid key")
    local cl = currentClicks[button]
    if cl and (cl.panel_key == key) and (not isClick(cl)) then
        -- its dragging this element!
        return cl.last_frame_dx, cl.last_frame_dy
    end
end



--- Returns true ONCE if the region was just pressed by a mouse-button.
--- (ie ONLY the frame after `mousepressed`.)
function iml.wasJustPressed(x,y,w,h, button, key)
    assertIsFrame()
    iml.panel(x,y,w,h, key)
    button = button or 1
    if clickPresses[button] then
        key = getKey(x,y,w,h,key)
        if wasTop(key) then
            return true
        end
    end
    return false
end


--- Returns true ONCE if the region was just released by a mouse-button.
--- (ie ONLY the frame after `mousepressed`.)
function iml.wasJustReleased(x,y,w,h, button, key)
    assertIsFrame()
    iml.panel(x,y,w,h, key)
    button = button or 1
    if clickReleases[button] then
        key = getKey(x,y,w,h,key)
        if wasTop(key) then
            return true
        end
    end
    return false
end





function iml.claimDrag(x,y,w,h, button, key)
    assertIsFrame()
    iml.panel(x,y,w,h, key)
    if iml.wasJustPressed(x,y,w,h, button, key) then
        -- claim the drag!
    end
end


function iml.endFrame()
    lastTopPanel = frameState.topPanel or nil
    frameCount = frameCount + 1
    clickReleases = {}
    clickPresses = {}
end



function iml.mousepressed(x, y, button, istouch, presses)
    -- "when mouse is pressed, store the widget that was pressed."
    local cl = {
        original_x=x,
        original_y=y,
        total_dx = 0,
        total_dy = 0,

        last_frame_dx = 0,
        last_frame_dy = 0,

        -- the panel that was just clicked!
        panel_key = (lastTopPanel and lastTopPanel.key) or nil
    }

    currentClicks[button] = cl
    clickPresses[button] = cl
end



function iml.mousereleased(x, y, button, istouch, presses)
    local cl = currentClicks[button]
    if isClick(cl) then
        clickReleases[button] = cl
    end
    currentClicks[button] = nil
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

