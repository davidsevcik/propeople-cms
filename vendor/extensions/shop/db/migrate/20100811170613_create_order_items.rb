class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.integer :product_page_id
      t.integer :order_id
      t.decimal :price, :precision => 10, :scale => 2
      t.integer :quantity, :default => 1
    end

    add_index :order_items, :product_page_id
    add_index :order_items, :order_id
  end

  def self.down
    drop_table :order_items
  end
end
