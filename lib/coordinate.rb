class Coordinate
	attr_accessor :x, :y
	def initialize coord
		@x = coord["x"] 
		@y = coord["y"]
	end
	def == coord
	 	return (@x == coord.x) && (@y == coord.y) ? true : false
	end
end	
