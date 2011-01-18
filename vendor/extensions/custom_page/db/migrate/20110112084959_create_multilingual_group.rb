class CreateMultilingualGroup < ActiveRecord::Migration
  def self.up
  	remove_column :pages, :multilingual_group
  	remove_index :pages, :multilingual_group
  	
  	create_table :multilingual_groups do |t|
  	
  	end
  	
  	add_column :pages, :multilingual_group_id, :integer
  	add_index :pages, :multilingual_group_id
  end

  def self.down
  	drop_table :multilingual_groups
  	
  	add_column :pages, :multilingual_group, :integer
  	add_index :pages, :multilingual_group
  	
  	remove_column :pages, :multilingual_group_id
  	remove_index :pages, :multilingual_group_id
  end
end
