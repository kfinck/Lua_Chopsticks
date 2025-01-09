local Player = {}
Player.__index = Player


require 'Util'


_G.Hand = require("Hand")

function Player.new(name, computer)
    local PlayerClass = setmetatable({}, Player)
    if name == "Player1" then
        PlayerClass.leftHand = Hand.new("left",180,300)
        PlayerClass.rightHand = Hand.new("right",220,300)
    elseif name == "Player2" then
        PlayerClass.leftHand = Hand.new("left",220,150)
        PlayerClass.rightHand = Hand.new("right",180,150)
    end
    PlayerClass.Computer = computer
    PlayerClass.hand_coords = Hand_coords[name]
    PlayerClass.name = name
    PlayerClass.swapAnimation = 0
    PlayerClass.slapAnimation = false 
    return PlayerClass

end

function Player:take(value, side)
    if side == 'left' then
        self.leftHand:take(value)
    elseif side == 'right' then
        self.rightHand:take(value)
    end
end

function Player:give(value, side)
    if side == 'left' then
        self.leftHand:give(value)
    elseif side == 'right' then
        self.rightHand:give(value)
    end
end

function Player:playSwapAnimation()
    print("playing swap animation 1")
    self.swapAnimation = 1
end

function Player:playSlapAnimation(attacker, defender)
    print("playing slap animation 1")
    self.slapAnimation = { attacker = attacker, defender = defender, phase = 1 } 

end

function Player:getHand(hand)
    if hand == 'left' then
        return self.leftHand
    else
	return self.rightHand
    end
end
function Player:getName()
    return self.name
end

function Player:getLowest()
    local rightValue = self.rightHand.count	 
    local leftValue = self.leftHand.count
    if leftValue > rightValue  and rightValue > 0 then
        return rightValue
    end
    return leftValue
end

function Player:getHighest()
    local rightValue = self.rightHand.count	 
    local leftValue = self.leftHand.count
    if leftValue > rightValue then
        return leftValue
    end
    return rightValue
end

return Player 
