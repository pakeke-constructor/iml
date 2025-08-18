


# PROBLEM SOLVE:


```lua

-- scroll bar:
-- HOW TO IMPLEMENT:


local function newScrollWindow(x,y,w,h)
    local sw = {
        scrollX = 0,
        scrollY = 0
    }

    local function beginScrollWindow(x,y,w,h)
        local r = Region(x,y,w,h)
        local main, scroll = r:splitHorizontal(0.9, 0.1)

        if iml.claimDrag(scroll:get()) then
            local dx,dy = iml.getDrag()
            sw.scrollY = sw.scrolld + dy
        end
    end

    local function endScrollWindow()
        love.graphics.setStencilTest()
    end

    return beginScrollWindow, endScrollWindow
end







```


