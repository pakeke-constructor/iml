


# PROBLEM SOLVE:

how the fakk should we do dis



```lua


function myButton(x,y,w,h)

    -- check pointer-position
    setColor(ui.isHovered(x,y,w,h) and RED or GREEN)
    rectangle(x,y,w,h)
    
    return ui.isClicked(x,y,w,h, button or nil)
end


```





