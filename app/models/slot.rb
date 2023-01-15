class Slot < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Slot", optional: true
  has_many :child_slots, class_name: "Slot", foreign_key: "slot_id"
end
