# frozen_string_literal: true

class UserMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: "users/mailer"
  # layout "users/mailer/welcome_reset_password_instructions"
  # layout "welcome_reset_password_instructions"
  layout "mailer"
  def welcome_reset_password_instructions(user, token)
    # create_reset_password_token(user)

    @token = token
    # send_devise_notification(:unlock_instructions, token)
    # mail(to: user.email, subject: "Welcome to the New Site")
  end
end
