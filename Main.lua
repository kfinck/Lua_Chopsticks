_G.love = require("love")
_G.math = require("math")

require 'Util'

_G.Player = require("Player")
_G.Hand = require("Hand")

_G.Hand_coords = {
    Player1 = { left = { x_min = 108, x_max = 170, y_min = 300, y_max = 380 }, right = { x_min = 223, x_max = 282, y_min = 300, y_max = 380 }},
    Player2 = { left = { x_min = 223, x_max = 282, y_min = 70, y_max = 143 }, right = { x_min = 108, x_max = 170, y_min = 70, y_max = 143 }}
}

function love.load()

    _G.Player1 = Player.new('Player1', false)
    _G.Player2 = Player.new('Player2', true)
    _G.currentTurn = Player1
    _G.opposingTurn = Player2
    _G.hands_sheet = love.graphics.newImage("/Assets/Hands-export.png")
    _G.hand_sprites = GenerateQuads(hands_sheet, 16*5, 16*5)

end

function CheckCollision(x,y)
    local opposing_coords = opposingTurn.hand_coords
    
    for hand,k in pairs(opposing_coords) do
        if x >= k['x_min'] and x <= k['x_max'] and  y >= k['y_min'] and y <= k['y_max'] then
            return hand
        end
    end
    return -1
end


function Attack(offense, defense)
    local attack_value = 0
    if offense == 'left' then
        attack_value = currentTurn.leftHand.count
    elseif offense == 'right' then
        attack_value = currentTurn.rightHand.count
    end
    print(attack_value)
    print(currentTurn.name .. " using " .. offense .. " on " .. opposingTurn.name .. "'s " .. defense)
    opposingTurn:take(attack_value, defense)
end

function love.mousereleased(x,y, button)
    



end

function love.mousepressed(x, y, button)
    local using_hand = 'none'
    if button == 1 then
        using_hand = 'left'
    elseif button == 2 then
        using_hand = 'right'
    else
        return
    end

    if currentTurn.leftHand.count == 0 and using_hand == 'left' then
        return
    end

    if currentTurn.rightHand.count == 0 and using_hand == 'right' then
        return
    end

    local collision = CheckCollision(x,y)
    if collision == -1 then
        return
    end

    if opposingTurn.rightHand.count == 0 and collision == 'right' then
        return
    end

    if opposingTurn.leftHand.count == 0 and collision == 'left' then
        return
    end

    Attack(using_hand, collision)
    local temp = opposingTurn
    _G.opposingTurn = currentTurn
    _G.currentTurn = temp
    
    

end

function love.update(dt)

end

function love.draw()
    love.graphics.setBackgroundColor(112/255, 115/255, 113/255)
    love.graphics.setColor(255,255,255)



    love.graphics.draw(hands_sheet, hand_sprites[Player1.leftHand.count + 1], 180,300, 0, -1, 1)
    love.graphics.draw(hands_sheet, hand_sprites[Player1.rightHand.count + 1], 220,300, 0, 1, 1)
    love.graphics.draw(hands_sheet, hand_sprites[Player2.rightHand.count + 1], 180,150, 0, -1, -1)
    love.graphics.draw(hands_sheet, hand_sprites[Player2.leftHand.count + 1], 220,150, 0, 1, -1)
end