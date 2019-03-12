--- === MouseCircle ===
---
--- Draws a circle around the mouse pointer when a hotkey is pressed
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/MouseCircle.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/MouseCircle.spoon.zip)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "MouseCircle"
obj.version = "1.0"
obj.author = "Chris Jones <cmsj@tenshu.net>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.circle = nil
obj.timer = nil
obj.show_circle = false
obj.circleRadius = 30


function obj:tick()
    if self.circle then
        self.circle:delete()
    end
    self.circle = nil

    if self.show_circle then
        local color = {["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1}
        local mousepoint = hs.mouse.getAbsolutePosition()
        
        circle = hs.drawing.circle(hs.geometry.rect(
            mousepoint.x-(obj.circleRadius / 2),
            mousepoint.y-(obj.circleRadius / 2),
            obj.circleRadius,
            obj.circleRadius))
        circle:setStrokeColor(color)
        circle:setFill(false)
        circle:setStrokeWidth(5)
        circle:bringToFront(true)
        circle:show()
        self.circle = circle

        hs.timer.doAfter(0.01, function() self:tick() end)
    end
end

function obj:toogle()
    if self.show_circle then
        self.show_circle = false
    else
        self.show_circle = true
        hs.timer.doAfter(0.0, function() self:tick() end)
    end
end

return obj
