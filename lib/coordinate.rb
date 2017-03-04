class Coordinate
	attr_accessor :x, :y
	def initialize coord
		@x = coord[0] 
		@y = coord[1]
	end
	def == coord
	 	return (@x == coord.x) && (@y == coord.y) ? true : false
	end
end	