# frozen_string_literal: true

Warden::JWTAuth.configure do |config|
  config.secret = Rails.application.secret_key_base
  config.dispatch_requests = [
    ["POST", %r{^/api/login$}],
    ["POST", %r{^/api/login.json$}],
    ["POST", %r{^/login$}],
    ["POST", %r{^/login.json$}]
  ]
  config.revocation_requests = [
    ["DELETE", %r{^/api/logout$}],
    ["DELETE", %r{^/api/logout.json$}],
    ["DELETE", %r{^/logout$}],
    ["DELETE", %r{^/logout.json$}]
  ]
end
