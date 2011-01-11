class AddMultilingualGroupToPages < ActiveRecord::Migration
  def self.up
  	add_column :pages, :multilingual_group, :integer
  	add_index :pages, :multilingual_group
  end

  def self.down
  	remove_column :pages, :multilingual_group
  end
end
