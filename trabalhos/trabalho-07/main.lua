larguraJanela = love.graphics.getWidth()
alturaJanela = love.graphics.getHeight()
fontSize = 40

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function createEnemies()
    x = 1200
    y = math.random(10,530)

    return function ()
    	x = x - (2)
    	if(x<0) then
    		x=1200
    		y=math.random(10,530)
    	end
        love.graphics.circle("fill", x, y, 10, 100)
        return x, y
    end

end

function love.load(dt)
	love.graphics.setBackgroundColor(30,144,255)
	fontPrincipal = love.graphics.newFont("fonts/Candy_Shop_Black.ttf", 60)
	fontAux = love.graphics.newFont("fonts/Candy_Shop_Black.ttf", 20)

	vivo = true
	player = {x = 10, y = alturaJanela/2, speed = 200, placar = 0}
	enemies = {}
	for i=1, 10 do
		enemies[i]={}
		enemies[i].enemy = createEnemies()
		enemies[i].x = 1200
		enemies[i].y = alturaJanela/2
	end 

end

function love.update(dt)
	--esc sai do jogo
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end


	--verificando as colisões
	vivo = true
	for i=1, 10 do
		collision = collision or CheckCollision(enemies[i].x, enemies[i].y, 40, 40, player.x, player.y, 100, 100) 
	end

	if (collision) then
		vivo= false
	end

	--Movimentação do personagem
	if love.keyboard.isDown('up','w') then
		if player.y > 50 then  --não passa do topo da tela
			player.y = player.y - (player.speed*dt)
		end
	elseif love.keyboard.isDown('down','s') then
		if player.y < (550) then -- não passa da base da tela
			player.y = player.y + (player.speed*dt)
		end
	end
	--Fim_Movimentação 
end

function love.draw()
		--desenhando as nuvens
		--nuvem 1
		love.graphics.setColor(255, 255, 255)
		love.graphics.ellipse("fill", 200, 100, 75, 50, 100)
		love.graphics.ellipse("fill", 315, 130, 75, 50, 100)
		love.graphics.ellipse("fill", 300, 75, 75, 50, 100)
		love.graphics.ellipse("fill", 400, 100, 60, 50, 100)
		--nuvem 2
		love.graphics.ellipse("fill", 800, 100, 75, 50, 100)
		love.graphics.ellipse("fill", 915, 130, 75, 50, 100)
		love.graphics.ellipse("fill", 900, 75, 75, 50, 100)
		love.graphics.ellipse("fill", 1000, 100, 60, 50, 100)

		love.graphics.setColor(255, 0, 0)
		love.graphics.circle("fill", player.x, player.y, 50, 100)

		if vivo then
			for i=1, 10 do
				enemies[i].x, enemies[i].y = enemies[i].enemy()
			end
		else
			love.graphics.setFont(fontPrincipal)
			love.graphics.print("Game Over", 300,200)
			love.graphics.print("Placar: ", 300,350)
			love.graphics.print(player.placar, 700,350)
			--love.graphics.setFont(fontAux)
			--love.graphics.print("Pressione R para Reiniciar ou ESC para Sair", 200,480)
		end
end
