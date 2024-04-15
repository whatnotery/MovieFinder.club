class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    # Customize the redirect path based on your requirements
    if resource.is_a?(User)
      # Redirect to a specific page for users
      discover_path
    else
      # Default redirect path
      super
    end
  end

  private

  def authorize_admin!
    unless current_user&.is_admin?
      render json: {error: "Unauthorized access"}, status: :unauthorized
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :first_name, :last_name])
  end
end
