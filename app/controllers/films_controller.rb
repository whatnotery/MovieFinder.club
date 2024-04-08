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

    def recently_discovered
        render json: Film.order('created_at DESC').limit(50)
    end

    def recently_reviewed
       render json: Film.joins(:reviews).order('reviews.created_at DESC').uniq.limit(50)
    end


    def random
        render json: Film.get_random_film(params["genre"], params["year"])
    end

    def search
        render json: Film.search(params["query"])
    end

    def twilio_response
        text_body = Film.param_array(params['Body'])
        args = Film.get_random_film_args(text_body)
        search_args = params['Body'].downcase.sub("search", "").strip
        if text_body.include?("search")
            render xml: Film.twiml(Film.search(search_args.titleize).first(3))
        end
        if text_body.include?("movie") && Film.genre_param_valid?(args['genre']) && Film.year_param_valid?(args['year'])
            film= Film.get_random_film(args['genre'], args['year']) 
            render xml: Film.twiml_error() unless film
            render xml: Film.twiml([film]) if film
        end
    end
    private

    def set_film
        @film = Tmdb::Movie.detail(params[:id])
        
        unless Film.find_by(mdb_id: params[:id])
            @film = Film.create(
                    mdb_id: @film["id"],
                    title: @film["title"].titleize, 
                    year: @film["release_date"].slice(0, 4), 
                    plot: @film["overview"],
                    poster: @film["poster_path"],
                    genres: @film["genre_ids"]
                    )
        else
            @film = Film.find_by(mdb_id: params[:id])
        end
    end
end
