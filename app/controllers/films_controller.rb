class FilmsController < ApplicationController
  before_action :authenticate_user!, only: %i[like unlike]
  before_action :set_film, only: %i[show like unlike liked_by]

  def index
    render json: Film.all.order(:year).order(:title).map { |film| Film.with_providers_and_trailer(film) }
  end

  def show
    render inertia: "pages/Film", props: {filmData: Film.with_providers_and_trailer(@film)}
  end

  def like
    @like = Like.new(film: @film, mdb_id: @film.mdb_id, user_id: current_user.id)

    if @like.save
      render json: {body: "#{@film.title} successfully liked by #{current_user.user_name}", status: 200}
    else
      render json: {body: "#{@film.title} is already liked by #{current_user.user_name}"}, status: :unprocessable_entity
    end
  end

  def unlike
    @like = Like.find_by(film_id: @film.mdb_id, user: current__user.id)
    if @like&.destroy
      render json: {message: "#{@film.title} successfully unliked by #{current_user.user_name}", status: 200}
    else
      render json: {errors: "#{@film.title} is not liked by #{current_user.user_name}"}, status: :unprocessable_entity
    end
  end

  def liked_by
    render json: @film.liked_by_users
  end

  def recently_discovered
    render inertia: "pages/Recent", props: {pageTitle: "Recently Discovered Films", filmsArray: Film.order("created_at DESC").limit(50)}
  end

  def recently_reviewed
    render inertia: "pages/Recent", props: {pageTitle: "Recently Reviewed Films", filmsArray: Film.joins(:reviews).order("reviews.created_at DESC").limit(50).uniq}
  end

  def search
    render json: Film.search(params["query"])
  end

  private

  def set_film
    @film = Tmdb::Movie.detail(params[:id])

    @film = Film.find_by(mdb_id: params[:id]) || Film.create(
      mdb_id: @film["id"],
      title: @film["title"].titleize,
      year: @film["release_date"].slice(0, 4),
      plot: @film["overview"],
      poster: @film["poster_path"],
      genres: @film["genre_ids"]
    )
  end
end
