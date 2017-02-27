class Grid
	
	attr_reader :area, :height, :width, :snakes, :me, :food

	def initialize args
		@height = args[:height]
		@width = args[:width]
		@food = args[:food] || []
		@me = args[:me]
		@snakes = args[:snakes] 
		@area = make_area
	end
	
	def print area = @area
		puts "\n\n" + " -   "*(@width + 2)
		print_lines = Array.new(@height)
		@height.times do |i|
			line = " |  "
			@width.times do |j|
				if area[j][i].is_a? String
					line += "  #{area[j][i]}  "
				elsif area[j][i] >= 0
					line += (area[j][i] == 0) ? '  .  ' : "  #{area[j][i]}  "
				else
					line += (area[j][i] == 0) ? '  .  ' : " #{area[j][i]}  "
				end
			end
			puts line + "  | \n\n"
		end	
		puts " -   "*(@width + 2)
		puts "\nWidth: #{@width} - Height: #{@height}\n\n"
	end

	# checks if point (x,y) is within the bounds of the grid.
	def within_bounds? x, y
		if ( (x < 0) && (x > @width-1)) 
			return false
		elsif  ( (y < 0) && (y > @height-1)) 
			return false
		else
			return true
		end
	end

	private

	def make_area
		area = @width.times.collect{Array.new(@height,0)}
		area = add_snakes(area)
		area = add_food(area)
		return area
	end

	# Adds snakes to the grid.
	# 
	# @params  [Array] grid
	# @returns [Array] grid
	def add_snakes area
		@snakes.each do |snake|
			me = (snake.id == @me)
			snake.body.each do |b|
				area[b.x][b.y] = me ? Config::ME_BODY : Config::ENEMY_BODY 
			end
			area[snake.head.x][snake.head.y] = me ? Config::ME_HEAD : Config::ENEMY_HEAD
		end
		return area
	end

	# Adds food to the grid.
	# 
	# @params  [Array] grid
	# @returns [Array] grid
	def add_food area
		@food.each do |f|
			area[f.x][f.y] = Config::FOOD
		end
		return area
	end

end