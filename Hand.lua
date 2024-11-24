local Hand = {}
Hand.__index = Hand

function Hand.new(handedness)
    local HandClass = setmetatable({}, Hand)
    HandClass.handedness = handedness
    HandClass.count = 1
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

return Hand 