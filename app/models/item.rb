class Item < ApplicationRecord
  belongs_to :user, optional: false, foreign_key: "user_id", inverse_of: :items
  belongs_to :slot, optional: false, foreign_key: "slot_id", inverse_of: :items

  validates :name, uniqueness: true
  validates :name, presence: true
  validates :code, uniqueness: {allow_nil: true}
end
