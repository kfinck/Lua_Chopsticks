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
    _G.r = 0
    math.randomseed(os.time())
end

function CheckCollision(x,y, player)
    local target_coords = currentTurn.hand_coords
    if player == 'opposing' then 	
        target_coords = opposingTurn.hand_coords
    end
    for hand,k in pairs(target_coords) do
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
    currentTurn:playSlapAnimation(currentTurn:getHand(offense), opposingTurn:getHand(defense))
end

function handle_swap(to, from)
    print( "invoking swap from " .. to .. " to " .. from .. ".")
    currentTurn:playSwapAnimation()
    currentTurn:take(1,from)
    currentTurn:give(1,to)
end


function doComputerTurn()
    local LR = {'left', 'right'}
    print("Computer's turn...")
    print("Right Power: " .. currentTurn.rightHand.count)
    print("Left Power: " .. currentTurn.leftHand.count)

    local SA = {'swap', 'attack'}
    local use = LR[math.random(1,2)]
    local move = SA[math.random(1,2)]
    local target = LR[math.random(1,2)]
    if currentTurn.leftHand.count <= 0 then
        use = 'right'
    elseif currentTurn.rightHand.count <= 0 then
        use = 'left'
    end
    if opposingTurn.leftHand.count < 0 then
        target = 'right'
    elseif opposingTurn.rightHand.count < 0 then
        target = 'left'
    end

    if math.abs(currentTurn.leftHand.count - currentTurn.rightHand.count) < 2 then
        move = 'attack'
    elseif use == 'left' then
        if currentTurn.leftHand.count < 1 or currentTurn.rightHand.count > 3 then
            move = 'attack'
        end
	target = 'right'
    elseif use == 'right' then
        if currentTurn.rightHand.count < 1 or currentTurn.leftHand.count > 3 then
            move = 'attack'
        end
	target = 'left'
    end

    if move == 'attack' then
	Attack(use,target)
    elseif move == 'swap' then

        handle_swap(use,target)
    end
end

function endGame()
   love.event.quit()
end

function swapTurns()
    local temp = opposingTurn
    _G.opposingTurn = currentTurn
    _G.currentTurn = temp
    if currentTurn.rightHand.count == 0 and currentTurn.leftHand.count == 0 then
        endGame()
    end
    if currentTurn.Computer then
        doComputerTurn()
	--swapTurns()
    end
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

    local swap_target = CheckCollision(x,y, 'same')
    if swap_target ~= -1 then
        if swap_target == using_hand then 
            return
        end
	if math.abs(currentTurn.leftHand.count - currentTurn.rightHand.count) < 2 then
       	    return
        end
        if using_hand == 'left' then
            if currentTurn.leftHand.count < 1 or currentTurn.rightHand.count > 3 then
		return
	    end
        end

        if  using_hand == 'right' then
            if currentTurn.rightHand.count < 1 or currentTurn.leftHand.count > 3 then
		return
	    end
        end
        handle_swap(using_hand, swap_target)
	--swapTurns()
	return
    end

    local collision = CheckCollision(x,y, 'opposing')
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

    --swapTurns()   
    

end

function love.update(dt)
     local rotateBy = 0.03
     local moveBy = 1
     
     if currentTurn:getName() == 'Player2' then 
	 moveBy = moveBy * -1
     end
     if currentTurn.swapAnimation == 1 and r < math.pi/5  then
         currentTurn.rightHand.rot = currentTurn.rightHand.rot - rotateBy
         currentTurn.leftHand.rot = currentTurn.leftHand.rot + rotateBy
	 r = currentTurn.leftHand.rot
         currentTurn.rightHand.x = currentTurn.rightHand.x - moveBy 
         currentTurn.leftHand.x = currentTurn.leftHand.x + moveBy 
     elseif currentTurn.swapAnimation  == 1 then
         currentTurn.swapAnimation = 2
     elseif currentTurn.swapAnimation == 2 and r > 0 then
         currentTurn.rightHand.rot = currentTurn.rightHand.rot + rotateBy
         currentTurn.leftHand.rot = currentTurn.leftHand.rot - rotateBy
	 r = currentTurn.leftHand.rot
         currentTurn.rightHand.x = currentTurn.rightHand.x + moveBy 
         currentTurn.leftHand.x = currentTurn.leftHand.x - moveBy 
     elseif currentTurn.swapAnimation == 2 then
         currentTurn.swapAnimation = 0
         currentTurn.rightHand.rot = 0
         currentTurn.leftHand.rot = 0
  	 swapTurns()
     end
     if currentTurn.slapAnimation ~= false then
             local attacker = currentTurn.slapAnimation['attacker']
	     local defender = currentTurn.slapAnimation['defender']
         if currentTurn.slapAnimation['phase'] == 1 and r < 60 then
	     attacker.x =  attacker.x  - (attacker.origX - defender.x)/60 * 1.7
	     attacker.y =  attacker.y  - (attacker.origY - defender.y)/60
	     r = r + 1
         elseif currentTurn.slapAnimation['phase'] == 1 then
             opposingTurn:take(attacker.count, defender:getSide())
	     currentTurn.slapAnimation['phase'] = 2
         elseif currentTurn.slapAnimation['phase'] == 2 and r > 0 then
	     attacker.x =  attacker.x  - (attacker.x - attacker.origX)/60 * 1.7
	     attacker.y =  attacker.y  - (attacker.y - attacker.origY)/60
	     r = r - 1
         elseif currentTurn.slapAnimation['phase'] == 2 then
	     attacker.x = attacker.origX
	     attacker.y = attacker.origY
	     r = 0
	     currentTurn.slapAnimation = false
	     swapTurns()
         end
     end

 end

function love.draw()
    love.graphics.setBackgroundColor(112/255, 115/255, 113/255)
    love.graphics.setColor(255,255,255)



    love.graphics.draw(hands_sheet, hand_sprites[Player1.leftHand.count + 1], Player1.leftHand.x - 30,Player1.leftHand.y + 40, Player1.leftHand.rot,  -1,  1, 30, 40) 
    love.graphics.draw(hands_sheet, hand_sprites[Player1.rightHand.count + 1], Player1.rightHand.x + 30,Player1.rightHand.y + 40, Player1.rightHand.rot, 1, 1, 30, 40)
    love.graphics.draw(hands_sheet, hand_sprites[Player2.rightHand.count + 1], Player2.rightHand.x - 30,Player2.rightHand.y - 40, Player2.rightHand.rot, -1, -1, 30, 40)
    love.graphics.draw(hands_sheet, hand_sprites[Player2.leftHand.count + 1], Player2.leftHand.x + 30,Player2.leftHand.y - 40, Player2.leftHand.rot, 1, -1, 30, 40)
end
