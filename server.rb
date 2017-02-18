require 'rubygems'
require 'sinatra'
require 'json'

set :port, ENV['PORT']

get '/' do
  return { message: 'Hello World'}.to_json
end

post '/start' do

end

post '/move' do

end

post '/end' do

end
