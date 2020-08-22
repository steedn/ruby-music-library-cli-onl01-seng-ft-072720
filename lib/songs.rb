class Song
    extend Concerns::Findable

    attr_accessor :name, :artist, :genre


    @@all = []

    def initialize(name, artist = nil, genre = nil)
        @name = name
        artist ? self.artist = artist : nil
        genre ? self.genre = genre : nil
    end

    def save
        @@all << self
    end

    def artist=(artist)
        @artist = artist
        @artist.add_song(self)
    end

    def genre=(genre)
        @genre = genre
        !@genre.songs.include?(self) ? @genre.songs << self : nil
    end

    def self.all
        @@all
    end

    def self.destroy_all
        @@all.clear
    end

    def self.create(name)
        song = Song.new(name)
        song.save
        song
    end

    def self.new_from_filename(name)
        artist, song, genre = name.split(' - ')
        genre = genre.gsub('.mp3', '')
        artist = Artist.find_or_create_by_name(artist)
        genre = Genre.find_or_create_by_name(genre)
        self.new(song, artist, genre)
    end

    def self.create_from_filename(file)
        self.new_from_filename(file).save
    end

end
