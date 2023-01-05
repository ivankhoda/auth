# frozen_string_literal: true

class JwtBlacklist
  include Devise::JWT::RevocationStrategies::Denylist
  def revoke_jwt(payload, user)
    super
  end
end
