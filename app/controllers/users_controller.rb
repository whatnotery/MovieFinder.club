class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy favorites likes reviews]
  before_action :authenticate_user!, only: %i[logged_in_user update destroy]
  before_action :authorize_admin!, only: %i[index]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render inertia: "pages/User", props: {
      user: @user,
      userFavorites: @user.favorite_films.order(:created_at),
      userLikes:  @user.liked_films.reverse,
      userReviews: @user.reviews.reverse
    }
  end

  def new
    render inertia: "pages/signUp"
  end

  def create
    @user = Users.create(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def logged_in_user
    render json: User.find(current_user.id)
  end

  def reviews
    if @user.reviews.any?
      render json: @user.reviews.reverse
    else
      head :no_content
    end
  end



  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by(user_name: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:user_name, :first_name, :last_name, :bio, :letterboxd, :instagram, :is_admin)
  end
end
