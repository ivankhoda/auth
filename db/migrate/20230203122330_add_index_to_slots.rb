class AddIndexToSlots < ActiveRecord::Migration[7.0]
  def change
    add_index :slots, [:user_id, :uuid]
  end
end
