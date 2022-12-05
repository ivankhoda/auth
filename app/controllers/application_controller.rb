class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?
  skip_before_action :verify_authenticity_token, if: :json_request?
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_auth_token
  before_action :set_current_user, if: :json_request?

  private

  def json_request?
    request.format.json?
  end

  # Use api_user Devise scope for JSON access
  def authenticate_user!(*args)
    super and return unless args.blank?
    json_request? ? authenticate_api_user! : super
  end

  def invalid_auth_token
    respond_to do |format|
      format.json { head 401 }
    end
  end

  def set_current_user
    @current_user ||= warden.authenticate(scope: :api_user)
  end

  def current_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:api_user, :email, :password])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:api_user, :email, :password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user, :email, :password])
    devise_parameter_sanitizer.permit(:login, keys: [:user, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:emails])
  end

  private

  # def current_user
  #   if @current_user ||= User.find_by(id:
  #                                       Auth.decode(request.env["HTTP_AUTHORIZATION"])["user"])
  #     response.headers["jwt"] = Auth.encode({user: @current_user.id})
  #   else
  #     render json: {error: {message: ["You must have a valid token"]}}
  #   end
  # end
end
