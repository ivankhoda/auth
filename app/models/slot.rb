class Slot < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Slot", foreign_key: "parent_id", optional: true

  has_many :items, foreign_key: "slot_id", inverse_of: :slot

  validates :name, :code, uniqueness: {scope: :user_id}
  validates :name, presence: true
end
