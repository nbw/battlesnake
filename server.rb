require 'rubygems'
require 'sinatra'

set :port, ENV['PORT']

get '/' do
  return 'Hello World'.to_json
end

post '/start' do

end

post '/move' do

end

post '/end' do

end
