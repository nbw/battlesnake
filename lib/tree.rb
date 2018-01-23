class Tree

	attr_reader :grid, :tree, :tree_bottom, :count
	def initialize grid
		@grid = grid
		@tree = nil
		@count = 1
		@tree_bottom = []
	end
	def build_tree
		head = @grid.my_snake.head
		@tree = Snode.new(parent:nil, dir: nil, coord: head, val: 0, sum: 0, level: 0)
		add_node(@tree)
	end
	def add_node parent	
		if parent.level >= Config::Tree::LEVELS
			@tree_bottom << parent
			return
		else
			
			current_path = get_path(parent)
			
			p_x, p_y = parent.coord.x, parent.coord.y

			avail_dir = ['left','right','up','down']
			tried_dir = []
			avail_dir.each do |dir| 
				case dir
					when "up";    x = p_x; y = p_y - 1
					when "down";  x = p_x; y = p_y + 1
					when "left";  x = p_x - 1; y = p_y
					when "right"; x = p_x + 1; y = p_y
				end		
				if @grid.traversable?(x,y) && !current_path.include?(Coordinate.new({"x"=> x, "y"=>y}))
					child = Snode.new(
						parent: parent,
						dir: dir,
						coord: Coordinate.new({"x"=> x, "y"=>y}),  
						val: grid.area[x][y], 
						sum: parent.sum + grid.area[x][y], 
						level: parent.level+1
					)
					parent.children << child
					@count += 1
					add_node(child)
				elsif !@grid.traversable?(x,y) || current_path.include?(Coordinate.new({"x"=> x, "y"=>y}))
					tried_dir << dir
				end
			end
			if avail_dir == tried_dir 
				puts "end of life! level: #{parent.level}"
				@tree_bottom << parent
			end 
		end
	end
	def get_path node, path = []
		if node.parent == nil
			path << node.coord
			return path
		else
			path << node.coord
			get_path(node.parent, path)
		end
	end
end
