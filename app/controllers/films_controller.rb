class FilmsController < ApplicationController
    require 'http'
    require 'twilio-ruby'

    def get_latest_film_id
        response = HTTP.get('https://api.themoviedb.org/3/movie/latest', :params => {:api_key => ENV['MOVIE_DB_API_KEY']
            })
        response.parse['id'] if response.status == 200
    end

    def get_random_film 
        movie_id = rand(get_latest_film_id);
        response = HTTP.get("https://api.themoviedb.org/3/movie/#{movie_id}", :params => {:api_key => ENV['MOVIE_DB_API_KEY']})
        data = response.parse if response.status == 200
        if data["adult"] == true || !data['title'] || !data['poster_path'] || !data['overview']
            get_random_film
        else
            data
        end
    end

    def index
       render json: get_random_film
    end

    def twilio
        data = get_random_film
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "#{data['original_title']} \n -------- \n  #{data['tagline']} \n -------- #{data['overview']}"

          end
        render xml: twiml
    end

end