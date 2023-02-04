class FilmsController < ApplicationController

    def index
        if params['genre'].present?
            render json: Film.get_random_film(params['genre'])
        else
            render json: Film.get_random_film()
        end
    end

    def twilio
        if params['Body'].length < 6
            render xml: Film.twiml()
        else
            render xml: Film.twiml(params['Body'][6..25].capitalize)
        end
    end

end