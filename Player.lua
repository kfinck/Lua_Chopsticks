local Player = {}
Player.__index = Player

_G.Hand = require("Hand")

function Player.new(name, computer)
    local PlayerClass = setmetatable({}, Player)
    PlayerClass.leftHand = Hand.new("left")
    PlayerClass.rightHand = Hand.new("right")
    PlayerClass.Computer = computer
    PlayerClass.hand_coords = Hand_coords[name]
    PlayerClass.name = name
    return PlayerClass

end

function Player:take(value, side)
    if side == 'left' then
        self.leftHand:take(value)
    elseif side == 'right' then
        self.rightHand:take(value)
    end
end

return Player 