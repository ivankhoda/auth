class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.string :code, null: false
      t.string :name

      t.timestamps
    end
    add_index :slots, :code, unique: true
    add_index :slots, :name, unique: true
  end
end
