# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user
  respond_to :json
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # super
  end

  # POST /resource/sign_in
  def create
    unless request.format == :json
      sign_out
      render status: 406, json: {message: "JSON requests only."} and return
    end

    resource = warden.authenticate!(auth_options)
    if resource.blank?
      render status: 401, json: {response: "Access denied."} and return
    end
    sign_in(resource_name, resource)
    render json: {success: true, jwt: current_token}
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  # def permitted_params
  #     params.require(:api_user).permit(:email, :password)
  #   end

  private

  def current_token
    request.env["warden-jwt_auth.token"]
  end

  def permitted_params
    params.require(:user).permit(:email, :password)
  end
end
