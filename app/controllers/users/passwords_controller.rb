# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :configure_update_password_parameters, only: [:update_password]
  respond_to :json, except: [:edit]

  def new
    super
    render json: {success: true, title: "Forgot password", html: render_to_string}
  end

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    render json: {success: true, text: "Check your email", reset_password_token: resource.token}
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
    # self.resource = resource_class.new
    # set_minimum_password_length
    # resource.reset_password_token = params[:reset_password_token]
  end

  def update
    pp(resource_params, "resource params")
    pp(params, "params")
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      render json: {success: true, user: resource}
      # respond_with resource, location: after_resetting_password_path_for(resource)
    else
      # respond_with resource
      render json: {success: false, message: resource.errors}
    end
  end

  private

  def configure_update_password_parameters
    parameters = [:password, :password_confirmation]
    devise_parameter_sanitizer.permit(:user, keys: parameters)
  end
end
