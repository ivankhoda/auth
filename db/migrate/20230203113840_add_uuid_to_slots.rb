class AddUuidToSlots < ActiveRecord::Migration[7.0]
  def change
    add_column :slots, :uuid, :string
    add_index :slots, :uuid
  end
end
