require 'rubygems'
require 'benchmark'
require 'sinatra'
require 'json'
require 'pry' if development?
require "sinatra/reloader" if development?
require 'awesome_print'

Dir["lib/*.rb"].each {|file| require_relative file }
Dir["config/*.rb"].each {|file| require_relative file }

set :port, ENV['PORT']
set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__) + '/public'
set :views, File.dirname(__FILE__) + '/public'

MODE = Settings.get("my_snake","st_method") # default Breadth first

get '/' do
  binding.pry
  erb :"test"
end

# Start game
#
# Example input
# {
#   "width": 20,
#   "height": 20,
#   "game_id": "b1dadee8-a112-4e0e-afa2-2845cd1f21aa"
# }
#
post '/start' do
  	return {
    	color: Settings.get("my_snake", "st_method") == "B" ? "#1869DF" : "#fc1047",
    	head_url: "http://www.feedrazzi.com/wp-content/uploads/2016/09/UVPAcWGcK.jpg",
      name: Settings.get("my_snake","name"),
    	taunt: "ゴロゴロ",
      head_type: "sand-worm",
      tail_type: "curled"
  	}.to_json
end

# Calculates the next move of my snake!
#
# @param Request
#
# @return [Hash] contains a move and taunt
#
# @example Response
#
# {
#   move: "up",
#   taunt: "gorogorogoro"
# }
#

post '/move' do
  requestBody = request.body.read
  parser = Parser.new(body: requestBody) 
  
  #1. Make a grid!
  g = Grid.new(
    width: parser.width, 
    height: parser.height,
    me: parser.you,
    snakes: parser.snakes.collect{|s| Snake.new(id: s["id"], coords: s["body"]["data"], health: s["health"])},
    food: parser.food.collect{|f| Food.new(x:f[0], y:f[1])}
  )
  # g.print

  #2. Paint that grid!
  p = Painter.new(g)
  p.paint
  p.grid.print

  #3. Make a tree with the painted grid!
  t = Tree.new(p.grid)
  t.build_tree

  #4. Use a squirrell to traverse the grid
  sq = Squirrel.new(tree: t)

  case MODE
  when "D"
    dir = sq.bottoms_up_method
  when "B"
    dir = sq.bfd_method
  else
    dir = sq.bfd_method
  end

	return {
  	move: dir,
  	taunt: ""
	}.to_json
end

post '/end' do
  return { message: 'Game over'}.to_json
end

