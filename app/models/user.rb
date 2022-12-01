class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :validatable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  before_create :add_jti
  def add_jti
    self.jti ||= SecureRandom.uuid
  end

  def jwt_payload
    super.merge("email" => email)
  end
end
