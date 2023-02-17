# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :configure_update_password_parameters, only: [:update_password]
  respond_to :json, except: [:edit]

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    render json: {success: true, text: "Check your email", reset_password_token: resource.token}
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      render json: {success: true, user: resource}
    else
      render json: {success: false, message: resource.errors}
    end
  end
end
