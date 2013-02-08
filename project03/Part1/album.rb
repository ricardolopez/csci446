class Album
	attr_accessor :title, :year, :rank

	def initialize(album_title, album_year, album_rank)
		@title = album_title
		@year = album_year
		@rank = album_rank
	end
end