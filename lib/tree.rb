require 'thread'

class TreeBuilder

	attr_reader :grid, :tree, :count
	def initialize grid
		@grid = grid
		@tree = nil
		@count = 1
		@mutex = Mutex.new
		@threads = []
	end
	def build_tree
		head = @grid.my_snake.head
		@tree = Snode.new(parent:nil, dir: nil, coord: head, val: 0, sum: 0, level: 0)
		add_node(@tree)
		@threads.each{|thread| thread.join}
	end
	def add_node parent, parent_dir = nil
		# threads = []
		# mutex = Mutex.new
		
		if parent.level >= Config::Tree::LEVELS
			return
		else
			@threads << Thread.new {
				p_x, p_y = parent.coord.x, parent.coord.y
				avail_dir = ['left','right','up','down']
				avail_dir.delete(parent_dir)

				avail_dir.each do |dir| 
					case dir
					when "up"
						x = p_x
						y = p_y - 1
						from_dir = "down"
					when "down"
						x = p_x
						y = p_y + 1
						from_dir = "up"
					when "left"
						x = p_x - 1
						y = p_y
						from_dir = "right"
					when "right"
						x = p_x + 1
						y = p_y
						from_dir = "left"
					end	
					if @grid.traversable?(x,y)
						
						child = Snode.new(
							parent: nil, #parent, <--- could be changed later
							dir: dir,
							coord: Coordinate.new([x,y]),  
							val: grid.area[x][y], 
							sum: parent.sum + grid.area[x][y], 
							level: parent.level+1)
							@mutex.synchronize do
								parent.children << child
								@count += 1
							end
							add_node(child,from_dir)
						
					end
				end
			}
		end
		
	end
end