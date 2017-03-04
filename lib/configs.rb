module GridConstants
	ENEMY_HEAD = '▓'
	ENEMY_BODY = '█'
	ME_HEAD = '▒'
	ME_BODY = '█'
	FOOD = "♥"
end

module PainterWallConstants
	module Walls
		DEGREE = 10
		WEIGHT = 0.25
	end
end

module TreeConstants
	module Tree
		LEVELS = 6
		MIN_THRESHOLD = 0.3
		THRESHOLD = 0.5
	end
end

module SnakeConstants
	module Snakes
		module Me
			BODY_DEGREE = 2
			BODY_WEIGHT = 1

			HEAD_DEGREE = 0
			HEAD_WEIGHT = -1
		end
		module Enemy
			BODY_DEGREE = 5
			BODY_WEIGHT = 1

			HEAD_DEGREE = 7
			HEAD_WEIGHT = 3
		end
	end
end

module FoodConstants
	module Food
		WEIGHT = -1
		DEGREE = 15
		MULT = 2
	end
end

class Config
	include GridConstants
	include PainterWallConstants
	include SnakeConstants
	include FoodConstants
	include TreeConstants
end

