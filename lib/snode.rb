class Snode
	attr_accessor :parent, :children, :dir, :coord, :val, :sum, :level
	def initialize parent:, dir:, level:, coord:, val:, sum:
		@coord = coord
		@dir = dir
		@level = level
		@val = val
		@sum = sum
		@parent = parent
		@children = []
	end
end