class Api::UsersController < ActionController::API
  def show
    render json: @user = User.find(params[:id])
  end
end
