# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :configure_update_password_parameters, only: [:update_password]
  respond_to :json

  def new
  end

  def create
  end

  def edit
  end

  def update
    pp(resource, "0000")
    # self.resource = resource_class.update(resource_params)
    # yield resource if block_given?
    #
    # if resource.errors.empty?
    #   render json: {success: true}
    # else
    #   respond_with resource
    # end
  end

  private

  def configure_update_password_parameters
    parameters = [:password, :password_confirmation]
    devise_parameter_sanitizer.permit(:user, keys: parameters)
  end
end
