# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
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
    if resource.update_without_password(account_update_params)
      render json: resource
    else
      render json: {errors: resource.errors}
    end
  end

  protected

  def resource
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  end

  def update_parameters
    parameters = %i[email password]
    devise_parameter_sanitizer.permit(:user, keys: parameters)
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

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
