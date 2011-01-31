class CreateProductPageFields < ActiveRecord::Migration
  def self.up
    create_table :product_page_fields do |t|
      t.integer :page_id
      t.string :perex_subtitle
      t.text :perex
    end
  end

  def self.down
    drop_table :product_page_fields
  end
end
