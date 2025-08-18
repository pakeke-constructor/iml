


# PROBLEM SOLVE:


```lua

-- scroll bar:
-- HOW TO IMPLEMENT:


local function newScrollWindow(x,y,w,h)
    local sw = {
        scrollX = 0,
        scrollY = 0
    }
    return sw
end

local Scroll = {}


function Scroll:begin(sw, x,y,w,h)
    local r = Region(x,y,w,h)
    local main, scroll = r:splitHorizontal(0.9, 0.1)

    iml.enableScroll(scroll:get())
    local dx, dy = iml.getDrag()
        sw.scrollY = sw.scrollY + dy
    end
end


function Scroll:finish(sw)
    love.graphics.setStencilTest()
end

```




