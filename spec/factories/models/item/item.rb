# frozen_string_literal: true

FactoryBot.define do
  factory :item, class: Item do
    sequence(:id) { |n| "#{n}" }
    sequence(:code) { |n| "A#{n}" }
    sequence(:name) { |n| "Test #{n}" }
  end
end
