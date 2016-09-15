player = { x = 50, y = 250, speed = 200, img = nil }
enemies = {}  --array dos inimigos criados
bullets = {} -- array dos tiros que serão desenhados
--[[
Nome: Tabela "bullets".
Propriedade: Criação da Tabela vazia que será usada para guardar os tiros.
Binding time: Compilação.
Explicação: Ao ser compilado em sua máquina virtual, o codigo Lua cria um espaço em memória para a tabela.
Porém seus itens só serão adicionados em tempo de execução.
]]
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
--[[
Nome: true.
Propriedades: Tipo de variável booleana.
Binding time: Design
Explicação: Ao projetar o design da linguagem, decide-se se a linguagem aceitará ou não o tipo de variavel booleana.
Ou se será feito alguma outra interpretação como 1 e 0 em outras linguagens.
]]

StartText = "Pressione Enter Para Iniciar"
GameOverText = "Game Over"
ResetText = "Pressione R para Reiniciar ou ESC para Sair"
fontSize = 40
--[[
Nome: Variável "fontSize".
Propriedade: Endereço de memória Global do programa principal.
Binding time: Compilação.
Explicação: Como a variável é global e seu valor ja é definido no inicio do programa, seu endereço pode
ser determinado no tempo de compilação do programa.
]]

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
	
	--Criação da imagem do Personagem
  	player.image = love.graphics.newImage('images/Aviao.png')

  	--Criação da imagem do tiro
  	bulletImg = love.graphics.newImage('images/Tiro.png')

  	--Criação da imagem do Inimigo
  	enemyImg = love.graphics.newImage('images/balao.png')

end

function love.update(dt)
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
		--[[
		Nome: table.insert.
		Propriedade: Insere um novo item a tabela.
		Binding time: Execução.
		Explicação: Ao clicar no botão espaço um novo item é adicionado a tabela "bullets".
		Isso só pode ser feito em tempo de execução pois depende da interação com o usuário.
		]]
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
		--[[
		Nome: player.y.
		Propriedade: Valor da variável.
		Binding time: Execução.
		Explicação: A variável player.y tem seu valor alterado no tempo de execução para cada vez que o jogador
		morre e deseje reiniciar o jogo.
		]]

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
--[[
Nome: Função "love.draw".
Propriedade: como a função é declarada.
Binding time: Design.
Explicação: No momento de Design da linguagem os projetistas decidem como será feito a declaração das funções.
]]
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
			for i, bullet in ipairs(bullets) do
		  		love.graphics.draw(bullet.img, bullet.x, bullet.y)
			end
			for i, enemy in ipairs(enemies) do
				love.graphics.draw(enemy.img, enemy.x, enemy.y, 0, 0.3, 0.3)
			end

			love.graphics.draw(player.image, player.x, player.y, 0, 0.1, 0.1) --desenhando o personagem
		else
			love.graphics.setFont(fontPrincipal)
			love.graphics.print(GameOverText, 300,200)
			love.graphics.print("Placar: ", 300,350)
			love.graphics.print(placar, 700,350)
			love.graphics.setFont(fontAux)
			love.graphics.print(ResetText, 200,480)
		end
	end
end