class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.string :code, null: false
      t.string :name
      t.belongs_to :user, index: true
      t.bigint :parent_id, foreign_key: true, index: true
      t.timestamps
    end
    add_index :slots, [:user_id, :code], unique: true
    add_index :slots, [:user_id, :name], unique: true
  end
end
