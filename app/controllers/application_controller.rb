class ApplicationController < ActionController::Base
  # before_action :configure_permitted_parameters, if: :devise_controller?
  include ActionController::ParamsWrapper
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :set_current_user, if: :json_request?
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_auth_token

  private

  def json_request?
    request.format.json?
  end

  def authenticate_user!(*args)
    unless user_signed_in?
      render json: {error: "Unauthorized"}, status: :unauthorized
    end
  end

  def invalid_auth_token
    respond_to do |format|
      format.json { head 401 }
    end
  end

  def set_current_user
    @current_user ||= warden.authenticate(scope: :user)
  end
end
