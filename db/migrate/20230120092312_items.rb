class Items < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :code
      t.string :name, null: false
      t.belongs_to :user, index: true
      t.belongs_to :slot, index: true
      t.timestamps
    end
    add_index :items, :code, unique: true
    add_index :items, :name, unique: true
  end
end
