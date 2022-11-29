# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    email { "some@example.com" }
    password { "AaBbCcDd" }
  end
end
