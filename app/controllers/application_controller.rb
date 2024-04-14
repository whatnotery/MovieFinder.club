class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def csrf_token
    render json: {csrfToken: form_authenticity_token}, status: :ok
  end

  private

  def authorize_admin!
    unless current_user&.is_admin?
      render json: {error: "Unauthorized access"}, status: :unauthorized
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :first_name, :last_name, :phone, :is_admin])
  end
end
