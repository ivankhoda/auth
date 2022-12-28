class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :validatable, :recoverable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  before_create :add_jti
  attr_reader :token
  def add_jti
    self.jti ||= SecureRandom.uuid
  end

  def jwt_payload
    super.merge("email" => email)
  end

  def send_reset_password_instructions(opts = {})
    token = set_reset_password_token
    # fall back to "default" config name
    opts[:client_config] ||= "default"
    send_devise_notification(:reset_password_instructions, token, opts)
    @token = token

    # UserMailer.new.welcome_reset_password_instructions(self, token)
    token
  end

  protected

  def set_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)

    self.reset_password_token = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
  end
end
