class FilmsController < ApplicationController
    require 'http'
    require 'twilio-ruby'

    def get_latest_film_id
        response = HTTP.get('https://api.themoviedb.org/3/movie/latest', :params => {:api_key => ENV['MOVIE_DB_API_KEY']
            })
        response.parse['id'] if response.status == 200
    end

    def get_random_film(*genre) 
        movie_id = rand(get_latest_film_id);
        response = HTTP.get("https://api.themoviedb.org/3/movie/#{movie_id}", :params => {:api_key => ENV['MOVIE_DB_API_KEY']})
        data = response.parse if response.status == 200
        if data["adult"] == true or !data['title'] or !data['poster_path'] or !data['overview'] or if genre.present? do !data['genre'][0];
            get_random_film
        else
            data
        end
    end

    def index
       render json: get_random_film
    end

    def twilio
        incoming = request.body.read
        #data = get_random_film
        #poster = "https://image.tmdb.org/t/p/w300/'#{data['poster_path']}"
        #imdb = "https://www.imdb.com/title/#{data['imdb_id']}"
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
           # r.message body: "#{data['original_title']} (#{data['release_date'].slice(0, 4)}) \n -------- \n #{data['overview']}", media_url: poster
           # r.message body: imdb
           r.message body: "#{incoming}"
          end
        render xml: twiml
    end

end