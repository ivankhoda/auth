# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :authenticate_user!, except: [:create]
  # before_action :configure_sign_up_params, only: [:create]

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: {errors: user.errors}, status: :unprocessable_entity
    end
  end

  # Patch /resource/edit
  def update
    @resource = resource
    if @resource.update_without_password(account_update_params)
      render json: {user: @resource}
    else
      render json: {errors: @resource.errors}, status: :unprocessable_entity
    end
  end

  protected

  def resource
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  private

  def current_token
    request.env["warden-jwt_auth.token"]
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
