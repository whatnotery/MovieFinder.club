class Api::FilmsController < ActionController::API
  def show
    @film = Tmdb::Movie.detail(params[:id])

    @film = Film.find_by(mdb_id: params[:id]) || Film.create(
      mdb_id: @film["id"],
      title: @film["title"].titleize,
      year: @film["release_date"].slice(0, 4),
      plot: @film["overview"],
      poster: @film["poster_path"],
      genres: @film["genre_ids"]
    )
    render json: @film
  end

  def random
    render json: Film.get_random_film
  end

  def search
    render json: Film.search(params["query"])
  end

  def twilio
    text_body = Film.param_array(params["Body"])
    args = Film.get_random_film_args(text_body)
    search_args = params["Body"].downcase.sub("search", "").strip
    if text_body.include?("search")
      render xml: Film.twiml(Film.search(search_args.titleize).first(3))
    end
    if text_body.include?("movie") && Film.genre_param_valid?(args["genre"]) && Film.year_param_valid?(args["year"])
      film = Film.get_random_film(args["genre"], args["year"])
      render xml: Film.twiml_error unless film
      render xml: Film.twiml([film]) if film
    end
  end
end
