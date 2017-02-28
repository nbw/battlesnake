class Painter
	attr_reader :grid
  	def initialize grid
    	@grid = grid
  	end

  	def paint grid = @grid #Grid class: grid, height, width
  		paint_walls
  		paint_snakes
  		paint_food
  	end

  	private

  	def paint_walls grid = @grid
  		degree = Config::Walls::DEGREE
  		weight = Config::Walls::WEIGHT
  		height = grid.height
  		width = grid.width

	  	width.times do |x|
	  		degree.times do |y|
	  			#top side
	  			if grid.area[x][y].is_a? Numeric
	  				grid.area[x][y] += (degree-y)*weight
	  			end
	  			# bottom side
	  			if grid.area[x][height-1-y].is_a? Numeric
	  				grid.area[x][height-1-y] += (degree-y)*weight
	  			end
	  		end	
	  	end

	  	height.times do |y|
	  		degree.times do |x|
	  			#left side
	  			if grid.area[x][y].is_a? Numeric
	  				grid.area[x][y] += (degree-x)*weight
	  			end
	  			# right side
	  			if grid.area[width-1-x][y].is_a? Numeric
	  				grid.area[width-1-x][y] += (degree-x)*weight
	  			end
	  		end	
	  	end
  	end

  	def paint_snakes grid = @grid
  		grid.snakes.each do |snake|
  			if snake.id == grid.me
  				configs = {
					head_degree:Config::Snakes::Me::HEAD_DEGREE,
					head_weight:Config::Snakes::Me::HEAD_WEIGHT,
					body_degree:Config::Snakes::Me::BODY_DEGREE,
					body_weight:Config::Snakes::Me::BODY_WEIGHT
				}
  			else 
				configs = {
					head_degree:Config::Snakes::Enemy::HEAD_DEGREE,
					head_weight:Config::Snakes::Enemy::HEAD_WEIGHT,
					body_degree:Config::Snakes::Enemy::BODY_DEGREE,
					body_weight:Config::Snakes::Enemy::BODY_WEIGHT
				}
  			end
  			paint_snake(snake:snake, configs: configs)
  		end
  	end

  	def paint_food grid: @grid
  		food = grid.food
  		degree = Config::Food::DEGREE
		weight = Config::Food::WEIGHT
  		vectors = []
  		food.each do |f|
  			f_x, f_y = f.x, f.y
			degree.times do |d|
				["left","right","up","down","leftup","leftdown","rightup","rightdown"].each do |dir|
					case dir
					when "left"
						vectors << PaintVector.new(dx: -1*(d + 1), dy: 0, val: weight*(degree-d))
					when "right"
						vectors << PaintVector.new(dx:(d + 1), dy: 0, val: weight*(degree-d))		
					when "up"
						vectors << PaintVector.new(dx:0, dy: -1*(d + 1), val: weight*(degree-d))
					when "down"
						vectors << PaintVector.new(dx:0, dy:(d + 1), val: weight*(degree-d))
					when "leftup"
						vectors += diagonal_vectors(degree: degree - (d), dx_mult: -1, dy_mult: -1, val: weight*(d+1))
					when "leftdown"
						vectors += diagonal_vectors(degree: degree - (d), dx_mult: -1, dy_mult: 1, val: weight*(d+1))
				when "rightup"
					vectors += diagonal_vectors(degree: degree - (d), dx_mult: 1, dy_mult: -1, val: weight*(d+1))
				when "rightdown"
					vectors += diagonal_vectors(degree: degree - (d), dx_mult: 1, dy_mult: 1, val: weight*(d+1))
					end
				end
			end
			vectors.each do |v|
				x = f_x + v.dx
				y = f_y + v.dy
				if grid.within_bounds?(x, y) && (grid.area[x][y].is_a? Numeric)
					grid.area[x][y] += v.val
				end
			end
			grid.area[f_x][f_y] = weight*(degree+1) # the food is actually a value too!
		end
  	end

  	def paint_snake snake:, grid: @grid, configs:
  		##############
  		# Head
  		##############
  		head_degree = configs[:head_degree]
  		head_weight = configs[:head_weight]
  		paintable_directions = snake.paintable_directions(snake.head)
  		head_vectors = snake_paint_vectors(paintable_directions: paintable_directions, degree: head_degree, weight: head_weight)
  		head_vectors.each do |v|
			x = snake.head.x + v.dx
			y = snake.head.y + v.dy
			if grid.traversable?(x,y)
				grid.area[x][y] += v.val
			end
		end

		##############
		# Body
		##############
  		body_degree = configs[:body_degree]
  		body_weight = configs[:body_weight]

  		snake.body.each do |coord|
  			vectors = []
  			s_x, s_y = coord.x, coord.y
  			paintable_directions = snake.paintable_directions(coord)
  			vectors += snake_paint_vectors(paintable_directions: paintable_directions, degree: body_degree, weight: body_weight)
  			vectors.each do |v|
  				x = s_x + v.dx
  				y = s_y + v.dy
  				if grid.traversable?(x,y)
	  				grid.area[x][y] += v.val
	  			end
  			end
  		end
  	end

  	def snake_paint_vectors paintable_directions:, degree:, weight:
  		vectors = []
		degree.times do |d|
			paintable_directions.each do |dir|
				case dir
				when "left"
					vectors << PaintVector.new(dx: -1*(d + 1), dy: 0, val: weight*(degree-d))
				when "right"
					vectors << PaintVector.new(dx:(d + 1), dy: 0, val: weight*(degree-d))		
				when "up"
					vectors << PaintVector.new(dx:0, dy: -1*(d + 1), val: weight*(degree-d))
				when "down"
					vectors << PaintVector.new(dx:0, dy:(d + 1), val: weight*(degree-d))
				when "leftup"
					vectors += diagonal_vectors(degree: degree - (d-1), dx_mult: -1, dy_mult: -1, val: weight*(d+1))
				when "leftdown"
					vectors += diagonal_vectors(degree: degree - (d-1), dx_mult: -1, dy_mult: 1, val: weight*(d+1))
			when "rightup"
				vectors += diagonal_vectors(degree: degree - (d-1), dx_mult: 1, dy_mult: -1, val: weight*(d+1))
			when "rightdown"
				vectors += diagonal_vectors(degree: degree - (d-1), dx_mult: 1, dy_mult: 1, val: weight*(d+1))
				end
			end
		end
		return vectors
  	end

  	def diagonal_vectors degree:, dx_mult:, dy_mult:, val:
  		return [] if degree <= 0

  		vectors = []
  		(degree-1).times do |d|
	  		da = degree-(d+1)
	  		db = d+1
	  		vectors << PaintVector.new(dx:dx_mult*da, dy:dy_mult*db, val: val)
	  	end
	  	return vectors
  	end
end
