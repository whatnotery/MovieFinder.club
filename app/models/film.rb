class Film < ApplicationRecord
    require 'http'

    def self.get_latest_film_id
        response = HTTP.get('https://api.themoviedb.org/3/movie/latest', :params => {:api_key => ENV['MOVIE_DB_API_KEY']
            })
        response.parse['id'] if response.status == 200
    end

    def self.get_random_film 
        movie_id = rand(Film.get_latest_film_id);
        response = HTTP.get("https://api.themoviedb.org/3/movie/#{movie_id}", :params => {:api_key => ENV['MOVIE_DB_API_KEY']})
        data = response.parse if response.status == 200
        if data["adult"] == true || !data['title'] || !data['poster_path'] || !data['overview']
            Film.get_random_film
        else
            data
        end
    end

    def self.twiml
        data = Film.get_random_film
        poster = "https://image.tmdb.org/t/p/w300/'#{data['poster_path']}"
        imdb = "https://www.imdb.com/title/#{data['imdb_id']}"
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "#{data['original_title']} (#{data['release_date'].slice(0, 4)}) \n -------- \n #{data['overview']}", media_url: poster
            r.message body: imdb
        end
    end
end
