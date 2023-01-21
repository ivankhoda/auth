# frozen_string_literal: true

FactoryBot.define do
  factory :slot, class: Slot do
    sequence(:id) { |n| "#{n}" }
    sequence(:code) { |n| "A#{n}" }
    sequence(:name) { |n| "Test #{n}" }

    # trait :user do
    #   user {user}
    # end
  end
end
