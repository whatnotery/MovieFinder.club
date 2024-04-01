class FilmsController < ApplicationController
    skip_before_action :verify_authenticity_token, raise: false  
    before_action :authenticate_devise_api_token!, only: %i[like unlike]
    before_action :set_film, only: %i[show like unlike liked_by]
    def index
        render json: Film.all.order(:year).order(:title).map { |film| Film.with_providers_and_trailer(film) }

    end

    def show
        render json: Film.with_providers_and_trailer(@film)
    end

    def like
        @like = Like.new(film: @film, user: current_devise_api_user)

        if @like.save
            render json: { message: "#{@film.title} successfully liked by #{current_devise_api_user.user_name}", status: 200 }
        else
          render json: { errors: "#{@film.title} is already liked by #{current_devise_api_user.user_name}" }, status: :unprocessable_entity
        end
    end

    def unlike
        @like = Like.find_by(film: @film, user: current_devise_api_user)
        if @like && @like.destroy
            render json: { message: "#{@film.title} successfully unliked by #{current_devise_api_user.user_name}", status: 200 }
        else
            render json: { errors: "#{@film.title} is not liked by #{current_devise_api_user.user_name}" }, status: :unprocessable_entity
        end  
    end

    def liked_by
        render json: @film.liked_by_users
    end

    def random
        render json: Film.get_random_film(params["genre"], params["year"]) if params["genre"].present? && params["year"].present?
        render json: Film.get_random_film(params["genre"]) if params["genre"].present? && params["year"].nil?
        render json: Film.get_random_film(nil, params["year"]) if params["genre"].nil? && params["year"].present? 
        render json: Film.get_random_film if params["genre"].nil? && params["year"].nil?
    end

    def twilio_response
        params_array = Film.param_array(params['Body'])
        args = Film.get_random_film_args(params_array)
        if !params_array.include?("movie") or !Film.genre_param_valid?(args["genre"]) && !Film.year_param_valid?(args["year"])
            render xml: Film.twiml_error()
        elsif params_array.include?('movie') && params_array.length == 1
            render xml: Film.twiml()
        elsif params_array.include?("movie") && params_array.include?('genre') && params_array.include?('year') && Film.genre_param_valid?(args["genre"]) && Film.year_param_valid?(args["year"])
            render xml: Film.twiml(args["genre"], args["year"])
        elsif params_array.include?("movie") && params_array.include?('genre') && Film.genre_param_valid?(args["genre"])
            render xml: Film.twiml(args["genre"])
        elsif params_array.include?("movie") && params_array.include?('year') 
            render xml: Film.twiml(nil, args["year"])
        else
            render xml: Film.twiml_error()
        end
    end

    def set_film
        @film = Tmdb::Movie.detail(params["id"])
        @film = Film.find_or_create_by(
                    mdb_id: @film["id"],
                    title: @film["title"], 
                    year: @film["release_date"].slice(0, 4), 
                    plot: @film["overview"],
                    poster: @film["poster_path"],
                    genres: @film["genre_ids"]
                    )
    end
end
