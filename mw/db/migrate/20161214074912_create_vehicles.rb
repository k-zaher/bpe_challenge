class CreateVehicles < ActiveRecord::Migration[5.0]
  def change
    create_table :vehicles do |t|
      t.string :name, null: false
      t.text :desc
      t.integer :state_id, null: false
      t.timestamps
    end
    add_index :vehicles, :state_id
  end
end
