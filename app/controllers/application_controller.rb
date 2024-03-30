class ApplicationController < ActionController::API
    before_action :configure_permitted_parameters, if: :devise_controller?

    private
  
    def authorize_admin!
      unless current_devise_api_user&.is_admin?
        render json: { error: 'Unauthorized access' }, status: :unauthorized
      end
    end

    protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :first_name, :last_name, :phone, :is_admin])
  end

end
