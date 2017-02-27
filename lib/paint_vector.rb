class PaintVector
	attr_reader :dx, :dy, :val
	def initialize args
		@dx = args[:dx]
		@dy = args[:dy]
		@val = args[:val]
	end
end