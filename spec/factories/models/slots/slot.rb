# frozen_string_literal: true

FactoryBot.define do
  factory :slot, class: Slot do
    sequence(:id) { |n| "#{n}" }
    sequence(:code) { |n| "A#{n}" }
    sequence(:name) { |n| "Test #{n}" }
    uuid { SecureRandom.uuid }
    user

    factory :slot_with_items do
      items do
        Array.new(5) { association(:item, slot: instance, user: instance.user) }
      end
    end
  end
end
