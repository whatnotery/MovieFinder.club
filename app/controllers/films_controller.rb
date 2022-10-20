class FilmsController < ApplicationController
    
    
    def index
       render json: Film.get_random_film
    end

    def twilio
        data = Film.get_random_film
        poster = "https://image.tmdb.org/t/p/w300/'#{data['poster_path']}"
        imdb = "https://www.imdb.com/title/#{data['imdb_id']}"
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "#{data['original_title']} (#{data['release_date'].slice(0, 4)}) \n -------- \n #{data['overview']}", media_url: poster
            r.message body: imdb
          end
        render xml: twiml
    end

end