class Album
	attr_accessor :name, :year, :rank

	def initialize(album_name, album_year, album_rank)
		@name = album_name
		@year = album_year
		@rank = album_rank
	end

	def self.read_file(name)
		@@albums = []
		rank = 1
		File.open(name, 'r').each_line do |line|
			attributes = line.split(", ")
			@@albums.push(Album.new(attributes[0], attributes[1], rank))
			rank += 1
		end
		@@albums
	end
end