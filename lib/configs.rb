module GridConstants
	ENEMY_HEAD = '▓'
	ENEMY_BODY = '█'
	ME_HEAD = '▒'
	ME_BODY = '█'
	FOOD = "♥"
end

module PainterWallConstants
	module Walls
		DEGREE = 3
		WEIGHT = 1
	end
end

module SnakeConstants
	module Snakes
		module Me
			BODY_DEGREE = 1
			BODY_WEIGHT = 1

			HEAD_DEGREE = 3
			HEAD_WEIGHT = 1
		end
		module Enemy
			BODY_DEGREE = 3
			BODY_WEIGHT = 1

			HEAD_DEGREE = 3
			HEAD_WEIGHT = 2
		end
	end
end

module FoodConstants
	module Food
		WEIGHT = -1
		DEGREE = 4
	end
end

class Config
	include GridConstants
	include PainterWallConstants
	include SnakeConstants
	include FoodConstants
end

