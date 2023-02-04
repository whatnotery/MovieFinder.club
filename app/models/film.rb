class Film < ApplicationRecord
    require 'http'
    require 'twilio-ruby'


    def self.get_latest_film_id
        response = HTTP.get('https://api.themoviedb.org/3/movie/latest', :params => {:api_key => ENV['MOVIE_DB_API_KEY']
            })
        response.parse['id'] if response.status == 200
    end

    def self.get_random_film(genre = nil)
        movie_id = rand(get_latest_film_id);
        response = HTTP.get("https://api.themoviedb.org/3/movie/#{movie_id}", :params => {:api_key => ENV['MOVIE_DB_API_KEY']})
        data = response.parse if response.status == 200
        if data.nil?
            data = get_random_film(genre)
        end
        if !movie_valid?(data)
          data = get_random_film(genre)
        end
        if !genre_valid?(data, genre)
          data = get_random_film(genre)
        end 
        return data
    end

    def self.movie_valid?(data)
        !data["adult"] == true and     
        !data["title"].blank? and
        !data['poster_path'].blank? and
        !data['overview'].blank? and
        !data["imdb_id"].blank?
    end

    def self.genre_valid?(data, genre=nil)
        if genre.nil?
            true
        elsif data['genres'].length < 1
            false        
        elsif data['genres'][0]['name'] == genre
            true
        else
            false
        end
    end

    def self.genre_param_valid?(genre_param)
        genre_list = ['Action', 'Adventure', 'Animation', 'Comedy', 'Crime', 'Documentary', 'Drama', 'Family', 'Fantasy', 'History', 'Horror', 'Music', 'Mystery', 'Romance', 'Science Fiction', 'Thriller', 'War', 'Western']
        genre_list.include?(genre_param.try(:titleize))
    end


    def self.twiml(params = nil)
        if params.nil?
            data = get_random_film()
        elsif genre_param_valid?(params)
            data = get_random_film(params)
        end
        poster = "https://image.tmdb.org/t/p/w300'#{data['poster_path']}"
        imdb = "https://www.imdb.com/title/#{data['imdb_id']}"
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "#{data['title']} (#{data['release_date'].slice(0, 4)}) #{!data['genres'].empty? ? [data['genres'][0]['name']] : ''} \n -------- \n #{data['overview']}"
            r.message body: imdb
        end
    end

    def self.twiml_error()
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "Please use the syntax 'Movie' for a completely random film and 'Movie:Genre' for a random film from a selected genre'"
            r.message body: 'Allowable genres are Action, Adventure, Animation, Comedy, Crime, Documentary, Drama, Family, Fantasy, History, Horror, Music, Mystery, Romance, Science Fiction, Thriller, War, and Western'
        end
    end
end


