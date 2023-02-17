# frozen_string_literal: true

FactoryBot.define do
  factory :item, class: Item do
    sequence(:id) { |n| "#{n}" }
    sequence(:code) { |n| "A#{n}" }
    sequence(:name) { |n| "Test #{n}" }
    # user

    trait :slot_id do |id|
      slot_id { id }
    end

    factory :item_with_slot do
      association :slot, factory: :slot
    end

  end
end
