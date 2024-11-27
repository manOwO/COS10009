# put your code here:
class Track
    attr_accessor :name, :location
end

def read_track(filename)
    a_file = File.open(filename, 'r')
    track = Track.new()
    track.name = a_file.gets()
    track.location = a_file.gets()
    return track
end

def print_track(track)
    puts('Track name: '+track.name)
    puts('Track location: '+track.location)
end

def main()
    track = read_track('track.txt')
    print_track(track)
end

main() if __FILE__ == $0 # leave this 