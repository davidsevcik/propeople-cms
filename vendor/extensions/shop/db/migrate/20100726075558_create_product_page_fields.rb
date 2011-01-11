class CreateProductPageFields < ActiveRecord::Migration
  def self.up
    create_table :product_page_fields do |t|
      t.integer :page_id
      t.decimal :price, :precision => 10, :scale => 2
    end
  end

  def self.down
    drop_table :product_page_fields
  end
end
