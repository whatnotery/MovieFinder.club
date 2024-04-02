class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false  
  before_action :authenticate_devise_api_token!
  before_action :set_user, only: %i[ show update destroy likes reviews ]
  before_action :authorize_admin! , only: %i[index show]


  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
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

  def current_user
    render json: current_devise_api_user
  end

  def likes
    if @user.liked_films.any?
      render json: @user.liked_films
    else
      head :no_content
    end
  end

  def reviews
    if @user.reviews.any?
      render json: @user.reviews
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
      params.require(:user).permit(:user_name, :first_name, :last_name, :phone, :is_admin)
    end
end
