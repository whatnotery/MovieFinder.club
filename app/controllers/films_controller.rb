class FilmsController < ApplicationController
    require 'http'
    require 'twilio-ruby'

    def get_latest_film_id
        response = HTTP.get('https://api.themoviedb.org/3/movie/latest', :params => {:api_key => ENV['MOVIE_DB_API_KEY']
            })
        response.parse['id'] if response.status == 200
    end

    def get_random_film(*genre)
        genre = genre[0].capitalize if genre.present?
        movie_id = rand(get_latest_film_id);
        response = HTTP.get("https://api.themoviedb.org/3/movie/#{movie_id}", :params => {:api_key => ENV['MOVIE_DB_API_KEY']})
        data = response.parse if response.status == 200 
        byebug
        if genre.present? and !data['genres'][0]['name'].nil?
            if (data["adult"] == true or data['title'].blank? or data['poster_path'].blank? or data['overview'].blank? or data['tagline'].blank? or data['genres'][0]['name'].present?)
                get_random_film(genre)
            elsif data["adult"] == true or !data['title'] or !data['poster_path'] or !data['overview'] or !data['tagline']
                get_random_film()
            else
                data
            end
        end
    end

    def index
       render json: get_random_film("#{params['genre']}")
    end

    def twilio
        data = get_random_film("#{params['body']}")
        poster = "https://image.tmdb.org/t/p/w300/'#{data['poster_path']}"
        imdb = "https://www.imdb.com/title/#{data['imdb_id']}"
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "#{data['original_title']} (#{data['release_date'].slice(0, 4)}) \n -------- \n #{data['overview']}", media_url: poster
            r.message body: imdb
          end
        render xml: twiml
    end

end