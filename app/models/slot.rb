class Slot < ApplicationRecord
  include SecureRandom

  belongs_to :user
  belongs_to :parent, class_name: "Slot", foreign_key: "parent_id", optional: true

  has_many :items, foreign_key: "slot_id", inverse_of: :slot
  has_many :slots, class_name: 'Slot', foreign_key: 'parent_id'

  validates :name, :code, uniqueness: {scope: :user_id}
  validates :name, presence: true

  before_create :generate_uuid


  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
