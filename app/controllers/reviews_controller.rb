class ReviewsController < ApplicationController
  before_action :set_film, only: [:index, :show, :create, :update, :destroy]
  before_action :set_review, only: [:show, :update, :destroy]
  before_action :authenticate_devise_api_token!, only: %i[create update destroy]

  def index
    render json: @film.reviews
  end

  # GET /reviews/1
  def show
    render json: @review
  end

  # POST /reviews
  def create
    @review = @film.reviews.create(review_params.merge(user: current_devise_api_user))

    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params) && @review.user == current_devise_api_user
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1
  def destroy
    @review.destroy if @review.user == current_devise_api_user
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_film
    @film = Tmdb::Movie.detail(params[:id])

    @film = Film.find_by(mdb_id: params[:id]) || Film.create(
      mdb_id: @film["id"],
      title: @film["title"],
      year: @film["release_date"].slice(0, 4),
      plot: @film["overview"],
      poster: @film["poster_path"],
      genres: @film["genre_ids"]
    )
  end

  def set_review
    @review = Review.find(params[:review_id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(:title, :rating, :body)
  end
end
