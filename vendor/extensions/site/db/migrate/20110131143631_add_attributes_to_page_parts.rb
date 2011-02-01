class AddAttributesToPageParts < ActiveRecord::Migration
  def self.up
    add_column :page_parts, :title, :string
    add_column :page_parts, :position, :integer
  end

  def self.down
  end
end
