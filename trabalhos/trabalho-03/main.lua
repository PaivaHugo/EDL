player = { x = 50, y = 250, speed = 200, img = nil }
enemies = {}  --array dos inimigos criados
bullets = {} -- array dos tiros que serão desenhados

canShoot = true
canShootTimerMax = 0.6 -- Está sincronizado com o som!!!
canShootTimer = canShootTimerMax

bulletImg = nil
enemyImg = nil

createEnemyTimerMax = 1.5 --define o tempo de criação dos inimigos
createEnemyTimer = createEnemyTimerMax

vivo = false
placar = 0

startBool = true

StartText = "Pressione Enter Para Iniciar"
GameOverText = "Game Over"
ResetText = "Pressione R para Reiniciar ou ESC para Sair"
fontSize = 40

-- os "retangulos" passadoa para essa função são os tiros e inimigos ou o player e o inimigo
-- Retorna verdadeiro se dois retangulos se "tocaram" e falso se não
-- x1,y1 são as coordenadas do topo esquerdodo primeiro "retangulo", w1,w2 são altura e largura
-- x2,y2,w2,y2 são do segundo "retangulo passado"
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load(dt)
	--Configurações de fundo e fonte
	love.graphics.setBackgroundColor(30,144,255)
	fontPrincipal = love.graphics.newFont("fonts/Candy_Shop_Black.ttf", 60)
	fontAux = love.graphics.newFont("fonts/Candy_Shop_Black.ttf", 20)
	
	
	--cria o som do tiro
	bulletSound = love.audio.newSource("sounds/Bullet.wav")
	--cria o som de fundo do avião
	--backgroundSound = love.audio.newSource("Airplane_Background.wav")
	
	--Criação da imagem do Personagem
  	player.image = love.graphics.newImage('images/Aviao.png')

  	--Criação da imagem do tiro
  	bulletImg = love.graphics.newImage('images/Tiro.png')

  	--Criação da imagem do Inimigo
  	enemyImg = love.graphics.newImage('images/balao.png')

end

function love.update(dt)
	--som de plano de fundo
	--love.audio.play(backgroundSound) --Não está tocando

	--esc sai do jogo   FAZER O BOTÃO SAIR!!!!
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	--Tempo entre os tiros
	canShootTimer = canShootTimer - (1*dt) --diminui em um a cada frame
	if canShootTimer < 0 then
	  canShoot = true --Depois de 2 frames ele pode atirar
	end

	--Atualiza a movimentação entre os tiros
	for i, bullet in ipairs(bullets) do
		bullet.x = bullet.x + (250 * dt)

	  	if bullet.x > love.graphics.getWidth() then 
			table.remove(bullets, i) --Remove os tiros que sairam da tela
		end
	end

	if love.keyboard.isDown('space') and canShoot then --(and canShoot)Impede que o jogador crie uma sequencia de tiros
	-- Criando cada tiro
		newBullet = { x = player.x + 70 , y = player.y + 30, img = bulletImg} --, sound = bulletSound }
		table.insert(bullets, newBullet)
		canShoot = false 
		canShootTimer = canShootTimerMax
	end

	-- Gambiarra para o som funcionar apenas uma vez por tiro
	if (love.keyboard.isDown('space') and vivo) then --Não funciona com tiros consecutivos
		love.audio.play(bulletSound)
	end
	--Cria Inimigos aleatórios
		-- tempo de criação
		createEnemyTimer = createEnemyTimer - (1 * dt)
		if createEnemyTimer < 0 then
			createEnemyTimer = createEnemyTimerMax

			-- Cria o inimigo e adiciona no array
			randomNumber = math.random(10, 530)
			newEnemy = { y = randomNumber, x = 1200, img = enemyImg }
			table.insert(enemies, newEnemy)
		end
	-- Atualiza a posição dos inimigos
	for i, enemy in ipairs(enemies) do
		enemy.x = enemy.x - (300 * dt)

		if enemy.y < 0 then -- remove o inimigo se ele passar do player(depois colocar para o jogo acabar caso isso ocorra)
			table.remove(enemies, i)
		end
	end

	--verificando as colisões
	for i, enemy in ipairs(enemies) do
	for j, bullet in ipairs(bullets) do
		if CheckCollision(enemy.x, enemy.y, 70, 70, bullet.x, bullet.y, 5, 5) then
			table.remove(bullets, j)
			table.remove(enemies, i)
			placar = placar + 1
		end
	end

	if CheckCollision(enemy.x, enemy.y, 70, 70, player.x, player.y, 70, 70) 
	and vivo then
		table.remove(enemies, i)
		vivo = false
	end
end

	--Movimentação do avião
	if love.keyboard.isDown('up','w') then
		if player.y > 0 then  --não passa do topo da tela
			player.y = player.y - (player.speed*dt)
		end
	elseif love.keyboard.isDown('down','s') then
		if player.y < (540) then -- não passa da base da tela
			player.y = player.y + (player.speed*dt)
		end
	end
	--Fim_Movimentação 

	--Verificações de Status
	if love.keyboard.isDown('return') and not vivo then
		-- reseta array de tiros e inimigos
		bullets = {}
		enemies = {}

		-- reseta timers
		canShootTimer = canShootTimerMax
		createEnemyTimer = createEnemyTimerMax
		-- move o player para o local de origem
		player.x = 50
		player.y = 250

		-- reseta o status do jogador
		placar = 0
		vivo = true
		startBool = false
	end

	if not vivo and love.keyboard.isDown('r') then
		-- reseta array de tiros e inimigos
		bullets = {}
		enemies = {}

		-- reseta timers
		canShootTimer = canShootTimerMax
		createEnemyTimer = createEnemyTimerMax

		-- move o player para o local de origem
		player.x = 50
		player.y = 250

		-- reseta o status do jogador
		placar = 0
		vivo = true
	end
end

function love.draw()

	if startBool then
		love.graphics.setFont(fontAux)
		love.graphics.print(StartText,350,200)
	else
			startBool = false
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

		if vivo then	
			--desenhando os Tiros
			for i, bullet in ipairs(bullets) do
		  		love.graphics.draw(bullet.img, bullet.x, bullet.y)
		  		--love.audio.play(bullet.sound) -- tirar duvida de porque o som fica repetido até sair do frame
			end

			--desenhando os balões inimigos
			for i, enemy in ipairs(enemies) do
				love.graphics.draw(enemy.img, enemy.x, enemy.y, 0, 0.3, 0.3)
			end

			love.graphics.draw(player.image, player.x, player.y, 0, 0.1, 0.1) --desenhando o personagem
		else
			-- tela de fim de jogo
			love.graphics.setFont(fontPrincipal)
			love.graphics.print(GameOverText, 300,200)
			love.graphics.print("Placar: ", 300,350)
			love.graphics.print(placar, 700,350)
			love.graphics.setFont(fontAux)
			love.graphics.print(ResetText, 200,480)
		end
	end
	-- IMPLEMENTAR DEPOIS!!!
	--if love.keyboard.isDown('up','w') then
	--	if player.y > 0 then
	--		love.graphics.draw(player.image, player.x, player.y, 0, 0.1, 0.1) --desenhando o personagem rotacionado para cima
	--	end
	--elseif love.keyboard.isDown('down','s') then
	--	if player.y < (love.graphics.getWidth() - player.img:getWidth()) then
	--		love.graphics.draw(player.image, player.x, player.y, 0, 0.1, 0.1) --desenhando o personagem rotacionado para baixo
	--	end

	--"botão de sair"
	--love.graphics.rectangle( "fill", 590, 10, 100, 50)

end