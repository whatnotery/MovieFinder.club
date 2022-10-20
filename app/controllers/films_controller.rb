class FilmsController < ApplicationController
    require 'twilio-ruby'

    def index
       render json: Film.get_random_film("#{params['genre']}")
    end

    def twilio
        data = Film.get_random_film("#{params['body']}")
        poster = "https://image.tmdb.org/t/p/w300/'#{data['poster_path']}"
        imdb = "https://www.imdb.com/title/#{data['imdb_id']}"
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "#{data['title']} (#{data['release_date'].slice(0, 4)}) \n -------- \n #{data['overview']}", media_url: poster
            r.message body: imdb
          end
        render xml: twiml
    end

end