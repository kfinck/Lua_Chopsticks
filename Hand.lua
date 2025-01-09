local Hand = {}
Hand.__index = Hand

function Hand.new(handedness, x, y)
    local HandClass = setmetatable({}, Hand)
    HandClass.handedness = handedness
    HandClass.count = 1
    HandClass.dragging = { active = false, diffX = 0, diffY = 0 }
    HandClass.x = x
    HandClass.y = y
    HandClass.origX = x
    HandClass.origY = y
    HandClass.rot = 0
    return HandClass

end


function Hand:take(value)
    local temp_value = self.count + value
    self.count = temp_value
    print("NEW VALUE")
    print(self.count)
    if temp_value > 4 then
        self.count = 0
    end
end

function Hand:give(value)
    local temp_value = self.count - value
    self.count = temp_value
    print("NEW VALUE")
    print(self.count)
end

function Hand:getSide()
    return self.handedness
end

return Hand 
