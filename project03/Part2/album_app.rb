require 'sinatra'
require 'data_mapper'
require_relative 'album'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/albums.sqlite3.db")
set :port, 8080

get '/form' do
	@sort_types = { "rank" => "Rank", "title" => "Title", "year" => "Year" }
	erb :form
end

post '/list' do
	@sort = params[:order]
	@highlight = params[:rank].to_i
	@albums = Album.all(:order => [@sort.to_sym.asc])
	erb :list
end