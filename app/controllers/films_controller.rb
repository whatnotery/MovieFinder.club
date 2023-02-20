class FilmsController < ApplicationController

    def index
        if params['genre'].present?
            render json: Film.get_random_film(params['genre'])
        else
            render json: Film.get_random_film()
        end
    end

    def twilio_response
        params_array = Film.param_array(params['Body'])
        args = Film.get_random_film_args(params_array)
        if !params_array.include?("movie") 
            render xml: Film.twiml_error()
        elsif params_array.include?('movie') && params_array.length == 1
            render xml: Film.twiml()
        elsif params_array.include?("movie") && params_array.include?('genre') && params_array.include?('year')
            render xml: Film.twiml(args["genre"], args["year"])
        elsif params_array.include?("movie") && params_array.include?('genre')
            render xml: Film.twiml(args["genre"])
        elsif params_array.include?("movie") && params_array.include?('year')
            render xml: Film.twiml(nil, args["year"])
        else
            render xml: Film.twiml_error()
        end
    end
end
