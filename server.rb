require 'rubygems'
require 'benchmark'
require 'sinatra'
require 'json'
require 'pry' if development?
require "sinatra/reloader" if development?
require 'awesome_print'

Dir["lib/*.rb"].each {|file| require_relative file }

set :port, ENV['PORT']
set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__) + '/public'
set :views, File.dirname(__FILE__) + '/public'

MODE = ENV['METHOD'] || 'B'

TEST_DATA = {
  "you": "25229082-f0d7-4315-8c52-6b0ff23fb1fb",
  "width": 25,
  "turn": 0,
  "snakes": [
    {
      "taunt": "git gud",
      "name": "my-snake",
      "id": "25229082-f0d7-4315-8c52-6b0ff23fb1fb",
      "health_points": 9,
      "coords": [[18,10],[15,10],[16,10],[17,10]]
    },
    {
      "taunt": "gotta go fast",
      "name": "other-snake",
      "id": "0fd33b05-37dd-419e-b44f-af9936a0a00c",
      "health_points": 50,
      "coords": [[3,5],[4,5],[5,5],[6,5],[7,5],[8,5],[9,5],[10,5],[10,6],[10,7]]
    }
  ],
  "height": 15,
  "game_id": "870d6d79-93bf-4941-8d9e-944bee131167",
  "food": [[18,5], 0,20],
  "dead_snakes": [
    {
      "taunt": "gotta go fast",
      "name": "other-snake",
      "id": "c4e48602-197e-40b2-80af-8f89ba005ee9",
      "health_points": 50,
      "coords": [[5,12],[5,12],[5,12]]
    }
  ]
}

get '/' do
  erb :"test"
end

post '/start' do
    # Example input

    # {
    #   "width": 20,
    #   "height": 20,
    #   "game_id": "b1dadee8-a112-4e0e-afa2-2845cd1f21aa"
    # }
  	return {
    	color: MODE == "B" ? "#1869DF" : "#00FF00",
    	head_url: "https://i.makeagif.com/media/9-26-2016/jFT1D0.gif",
    	name: "ゴロゴロ",
    	taunt: "swish",
      head_type: "sand-worm",
      tail_type: "curled"
  	}.to_json
end

# Calculates the next move of my snake!
#
# @params Request
#
# {
#   "you": "25229082-f0d7-4315-8c52-6b0ff23fb1fb",
#   "width": 2,
#   "turn": 0,
#   "snakes": [
#     {
#       "taunt": "git gud",
#       "name": "my-snake",
#       "id": "25229082-f0d7-4315-8c52-6b0ff23fb1fb",
#       "health_points": 93,
#       "coords": [[0,0],[0,0],[0,0]]
#     },
#     {
#       "taunt": "gotta go fast",
#       "name": "other-snake",
#       "id": "0fd33b05-37dd-419e-b44f-af9936a0a00c",
#       "health_points": 50,
#       "coords": [[1,0],[1,0],[1,0]]
#     }
#   ],
#   "height": 2,
#   "game_id": "870d6d79-93bf-4941-8d9e-944bee131167",
#   "food": [[1,1]],
#   "dead_snakes": [
#     {
#       "taunt": "gotta go fast",
#       "name": "other-snake",
#       "id": "c4e48602-197e-40b2-80af-8f89ba005ee9",
#       "health_points": 50,
#       "coords": [[5,0],[5,0],[5,0]]
#     }
#   ]
# }
#
# @returns [Hash] contains a move and taunt
#
# @example Response
#
# {
#   move: sq.bottoms_up_method,
#   taunt: "gorogorogoro"
# }
#

post '/move' do
  requestBody = request.body.read
  req = requestBody ? JSON.parse(requestBody) : {}

  #1. Make a grid!
  g = Grid.new(
    width: req["width"], 
    height: req["height"],
    me: req["you"],
    snakes: req["snakes"].collect{|s| Snake.new(id: s["id"], coords: s["coords"], health: s["health_points"])},
    food: req["food"].collect{|f| Food.new(x:f[0], y:f[1])}
  )
  # g.print

  #2. Paint that grid!
  p = Painter.new(g)
  p.paint
  # p.grid.print

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
  	taunt: "gorogorogoro"
	}.to_json
end

post '/end' do
  return { message: 'Game over'}.to_json
end

