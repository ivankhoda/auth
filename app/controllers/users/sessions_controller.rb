# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user
  respond_to :json

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
    response.set_header("jwt", current_token)
    render json: {success: true, jwt: current_token}
  end

  # DELETE /resource/sign_out
  def destroy
    r = "Successfully signed out."
    status = 200
    if warden.authenticated?(auth_options)
      sign_out
    else
      status = 401
      r = "You are not authorized."
    end

    render status: status, json: {message: r}
  end

  private

  def current_token
    request.env["warden-jwt_auth.token"]
  end

  def permitted_params
    params.require(:user).permit(:email, :password)
  end
end
