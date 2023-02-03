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
        byebug
        if !movie_valid?(data)
           get_random_film()
        end
        if !genre_valid?(data, genre)
          get_random_film(genre)
        end
        data
    end

    def self.movie_valid?(data)      
        data["adult"] == "false" or
        !data['title'].blank? or
        !data['poster_path'].blank? or
        !data['overview'].nil? or
        !data['tagline'].nil?  
    end

    def self.genre_valid?(data, *genre)
      if !genre
        true
      else
        !data['genres'].empty? and
        data['genres'][0]['name'] == genre
      end
    end

    def self.twiml(*params)
        if params.empty?
            data = Film.get_random_film()
        else
            data = Film.get_random_film(params)
        end
        poster = "https://image.tmdb.org/t/p/w300/'#{data['poster_path']}"
        imdb = "https://www.imdb.com/title/#{data['imdb_id']}"
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "#{data['title']} (#{data['release_date'].slice(0, 4)}) [#{data['genres'][0]['name']}] \n -------- \n #{data['overview']}"
            r.message body: imdb
        end
    end
end
