require 'rack'
require 'erb'
require 'sqlite3'
require_relative 'album'

class AlbumApp

 	def initialize
 		@db = SQLite3::Database.new("albums.sqlite3.db")
 		@albums = get_all_albums
 		@sort_types = { "rank" => "Rank", "title" => "Title", "year" => "Year"}
 	end

	def call(env)
		request = Rack::Request.new(env)
		case request.path
		when "/form" then render_form(request)
		when "/list" then render_list(request)
		when "/style.css" then render_style(request)
		else render_404
		end
	end

	def render_form(request)
		response = Rack::Response.new
		template = ERB.new(File.open("form.erb", "r") { |form| form.read })
		response.write(template.result(binding))
		response.finish
	end

	def render_list(request)
		response = Rack::Response.new
		template = ERB.new(File.open("list.erb", "r") { |list| list.read })
		@sort = request["order"]
		@highlight = request["rank"].to_i
		@albums = sort_albums(@sort)
		response.write(template.result(binding))
		response.finish
	end

	def render_style(request)
		response = Rack::Response.new
    	response.write(File.open("style.css", "r") { |style| style.read })
     	response.finish
	end

	def render_404
		[404, {"Content-type" => "text/plain"}, ["Could not fetch the requested page"]]  
	end

	def get_all_albums
		result = @db.execute("SELECT * FROM albums;")
		create_list(result)
	end

	def sort_albums(sort_type)
		result = @db.execute("SELECT * FROM albums ORDER BY #{sort_type};")
		create_list(result)
	end

	def create_list(db_results)
		albums = Array.new
		db_results.each do |row|
			albums.push(Album.new(row[1], row[2], row[0]))
		end
		albums
	end

end

Rack::Handler::WEBrick.run AlbumApp.new, :Port => 8080