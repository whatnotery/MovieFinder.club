class FilmsController < ApplicationController
    
    
    def index
        render json: Film.get_random_film
    end

    def twilio
        render xml: Film.twiml
    end

end