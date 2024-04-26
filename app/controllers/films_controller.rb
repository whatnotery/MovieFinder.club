class FilmsController < ApplicationController
  before_action :authenticate_user!, only: %i[like unlike favorite unfavorite]
  before_action :set_film, only: %i[show like unlike favorite unfavorite liked_by]

  def index
    render json: Film.all.order(:year).order(:title).map { |film| Film.with_providers_and_trailer(film) }
  end

  def show
    render inertia: "pages/Film", props: {filmData: Film.with_providers_and_trailer(@film), liked: @film.liked_by_users.include?(current_user), favorite: @film.favorited_by_users.include?(current_user)}
  end

  def like
    @like = Like.new(film: @film, mdb_id: @film.mdb_id, user: current_user)

    if @like.save
      render json: {body: "#{@film.title} successfully liked by #{current_user.user_name}", status: 200}
    else
      render json: {body: "#{@film.title} is already liked by #{current_user.user_name}"}, status: :unprocessable_entity
    end
  end

  def unlike
    @like = Like.find_by(film: @film, mdb_id: @film.mdb_id, user: current_user)
    if @like&.destroy
      render json: {message: "#{@film.title} successfully unliked by #{current_user.user_name}", status: 200}
    else
      render json: {errors: "#{@film.title} is not liked by #{current_user.user_name}"}, status: :unprocessable_entity
    end
  end

  def favorite
    @favorite = Favorite.new(film_id: @film.id, mdb_id: @film.mdb_id, user: current_user)
    puts "does @favorite save #{@favorite.save}"
    if @favorite.save
      render json: {body: "#{@film.title} successfully favorited by #{current_user.user_name}", status: 200}
    else
      render json: {body: "#{@film.title} is already favorited by #{current_user.user_name}"}, status: :unprocessable_entity
    end
  end

  def unfavorite
    @favorite = Favorite.find_by(film_id: @film.id, mdb_id: @film.mdb_id, user: current_user)
    if @favorite&.destroy
      render json: {body: "#{@film.title} successfully unfavorited by #{current_user.user_name}", status: 200}
    else
      render json: {body: "#{@film.title} is not favorited by #{current_user.user_name}"}, status: :unprocessable_entity
    end
  end

  def liked_by
    render json: @film.liked_by_users
  end

  def recent
    render inertia: "pages/Recent", props: {likedFilms: Film.joins(:likes).order("likes.created_at DESC").limit(50).uniq, reviewedFilms: Film.joins(:reviews).order("reviews.created_at DESC").limit(50).uniq}
  end

  def search
    render inertia: "pages/Search"
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
