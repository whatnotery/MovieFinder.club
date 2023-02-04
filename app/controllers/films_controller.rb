class FilmsController < ApplicationController

    def index
        if params['genre'].present?
            render json: Film.get_random_film(params['genre'])
        else
            render json: Film.get_random_film()
        end
    end

    def twilio
        if params['Body'][0..4].downcase != 'movie' 
            render xml: Film.twiml_error()
        elsif params['Body'].length >= 6 and !Film.genre_param_valid?(params['Body'][6..40].try(:titleize))
            render xml: Film.twiml_error()
        elsif Film.genre_param_valid?(params['Body'][6..40].try(:titleize))
            render xml: Film.twiml(params['Body'][6..40].titleize)
        else
            render xml: Film.twiml()
        end
    end

end