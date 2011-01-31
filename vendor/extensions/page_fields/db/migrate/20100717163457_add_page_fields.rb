class AddPageFields < ActiveRecord::Migration
  def self.up
    create_table :page_fields do |t|
      t.integer :page_id
      t.string :name
      t.string :caption
      t.text :content
      t.integer :type, :default => 0
      t.boolean :erasable, :default => true
    end
    add_index :page_fields, :page_id
  end

  def self.down
    remove_index :page_fields, :page_id
    drop_table :page_fields
  end
end
