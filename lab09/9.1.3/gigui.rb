require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

# differentiate elements of the page

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

# store the genre easier

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

# display an artwork of an album by getting the artwork's location

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

# store an album's information (divide into attrbutes)

class Album
	attr_accessor :title, :artist, :artwork, :release_date, :genre, :tracks

	def initialize (title, artist, artwork, release_date, genre, tracks)
		# insert lines here
		@title = title
		@artist = artist 
		@artwork = artwork
		@release_date = release_date
		@genre = genre
		@tracks = tracks
	end
end

# store a track's information (a track belongs to tracks in an album)

class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

# main GUI music player

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 800, 600
	    self.caption = "Music Player"

		# Reads in an array of albums from a file and 
		# then prints all the albums in the
		# array to the terminal

		music_file = File.new("albums.txt", "r")
		@albums = load(music_file)
		music_file.close()
		for i in (0..@albums.length()-1)
			puts (i+1).to_s + " " + @albums[i].title 
			puts @albums[i].artist
			puts @albums[i].artwork.bmp 
			puts @albums[i].release_date
			puts('Genre is ' + @albums[i].genre.to_s)
			puts(GENRE_NAMES[@albums[i].genre])
			
			# to get tracks information of the album

			for f in (0..@albums[i].tracks.length()-1)
				puts(@albums[i].tracks[f].name)
				puts(@albums[i].tracks[f].location)
			end
		end
		
		@track_font = Gosu::Font.new(15)
		
	end

  # Load albums and tracks having the music file read

  def load(music_file)
	albums = []
	count = music_file.gets().chomp().to_i
	for i in (1..count)
		album_artist = music_file.gets().chomp
		album_title = music_file.gets().chomp
		album_artwork = ArtWork.new(music_file.gets().chomp)
		album_release_date = music_file.gets.chomp
		album_genre = music_file.gets().chomp.to_i
		album_tracks = music_file.gets().chomp.to_i
		
		tracks = []
		for i in (1..album_tracks)
			track_name = music_file.gets.chomp
			track_location = music_file.gets.chomp
			track = Track.new(track_name, track_location)
			tracks << track
		end

		album = Album.new(album_title, album_artist, album_artwork, album_release_date, album_genre, tracks)
		albums << album
	end
	
	return albums
  end 

  # Draws the artwork on the screen for all the albums

  def draw_albums albums
	album_scale = 1
	position_x = 10
	position_y = 10
	for i in (0..albums.length()-1)
		@albums[i].artwork.bmp.draw(position_x, position_y, 0, album_scale, album_scale)
		if i%2 == 0
			position_x += 250
		else
			position_x = 10
			position_y += 250
		end
	end
	
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

  def area_clicked(leftX, topY, rightX, bottomY)
	if mouse_x.between?(leftX, rightX) && mouse_y.between?(topY, bottomY)
		return true 
	else 
		return false
	end
	
  end


  # Takes a String title and an Integer ypos (y position), 
  # drawing the track's title at its ypos
  def display_track(title, ypos)
	@track_font.draw(title, 500, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
  end


  # Takes a track index and an Album and plays the Track from the Album

	def playTrack(track, album)
		# complete the missing code
			@song = Gosu::Song.new(album.tracks[track].location)
			@song.play(false)
	# Uncomment the following and indent correctly:
	#	end
	# end
	end

  # Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		draw_quad(0, 0, TOP_COLOR, 800, 0, TOP_COLOR, 0, 600, BOTTOM_COLOR, 800, 600, BOTTOM_COLOR, ZOrder::BACKGROUND)
	end

  # Not used? Everything depends on mouse actions
	def update
	end

  # Draws the album images and the track list for the selected album

	def draw
		draw_background #call function to draw background
		draw_albums @albums #call function to draw album images
		
		# if a song is selected and is playing, 
		# display a message indicate that the song is playing right now

		if @song_playing_track_no
			if @song.playing?
				Gosu::Font.new(17).draw("Now playing track \n#{@albums[@song_playing_album_no].tracks[@song_playing_track_no].name} \nFrom album #{@albums[@song_playing_album_no].title} \nBy artist #{@albums[@song_playing_album_no].artist}", 500, 400, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
			end
		end

		# if an album is clicked on, display all tracks in that album

		ypos = 100
		if @no_album_clicked 
			for f in (0..@albums[@no_album_clicked].tracks.length-1)
				track_displayed = display_track(@albums[@no_album_clicked].tracks[f].name, ypos)
				ypos += 15
			end
		end
	end

 	def needs_cursor?; true; end

	# If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu

	def button_down(id)
		case id
	    when Gosu::MsLeft
	    	
			# if an album is clicked on already, 
			# run this code to check if a track in that album is clicked on

			if @no_album_clicked 
				ypos = 100
				for i in (0..@albums[@no_album_clicked].tracks.length-1)
					
					# if a track is selected to play 

					if area_clicked(510, ypos, 800, ypos+60)
						
						# the currently playing song information is saved and played

						@song_playing_track_no = i
						@song_playing_album_no = @no_album_clicked 
						playTrack(@song_playing_track_no, @albums[@song_playing_album_no])
					end
					ypos += 15
				end
			end

			# albums on the screen have different positions, 
			# so this code is used to get the positions of those albums 
			# to check for album clicked

			album_side = 250
			for i in (0..@albums.length()-1)
				if i == 0
					position_x = 10
					position_y = 10
				elsif i%2 == 1
					position_x += album_side + 20
				else
					position_x = 10
					position_y += album_side + 20
				end
				
				# if an album is chosen, store the album clicked on. 
				# (this information is used to display tracks)

				if area_clicked(position_x, position_y, position_x+album_side, position_y+album_side)
					@no_album_clicked = i 
				end
	    	end

			
		end
	end
end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0