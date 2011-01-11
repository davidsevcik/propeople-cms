class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :name
      t.string :surname
      t.string :company
      t.string :email
      t.string :phone
      t.string :street
      t.string :city
      t.string :zip
      t.string :delivery_name
      t.string :delivery_surname
      t.string :delivery_street
      t.string :delivery_city
      t.string :delivery_zip
      t.string :delivery_phone
      t.integer :state_id
      t.timestamps
    end

    add_index :orders, :state_id
  end

  def self.down
    drop_table :orders
  end
end
