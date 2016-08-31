function love.load()
	text = "Hugo Paiva"
	font = love.graphics.newFont("Candy_Shop.ttf", 36) --alterado do Screenshot para funcionar com a fonte no mesmo diretótio.
	love.graphics.setFont(font)

	x, y = 10, 10
end
	
function love.update(dt)
	if love.keyboard.isDown("s") then
		y = y + 10
	elseif love.keyboard.isDown("w") then
	    y = y - 10
	elseif love.keyboard.isDown("d") then
		x = x + 10
	elseif love.keyboard.isDown("a") then
	    x = x - 10
	end 
end

function love.draw()
	--love.graphics.draw(fundo, 0, 0)
	love.graphics.print(text, x, y)	
end