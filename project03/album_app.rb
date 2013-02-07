require 'rack'
require 'erb'
require_relative 'album'

class AlbumApp

 	def initialize
 		@list = Album.read_file("top_100_albums.txt")
 		@sort_types = { "rank" => "Rank", "name" => "Name", "year" => "Year"}
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
		case @sort
		when "rank" then @list.sort_by! { |a| a.rank }
		when "name" then @list.sort_by! { |a| a.name }
		when "year" then @list.sort_by! { |a| a.year }
		end
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
end

Rack::Handler::WEBrick.run AlbumApp.new, :Port => 8080