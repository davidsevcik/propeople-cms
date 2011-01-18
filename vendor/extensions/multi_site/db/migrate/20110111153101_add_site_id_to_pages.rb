class AddSiteIdToPages < ActiveRecord::Migration
  def self.up
  	add_column :pages, :site_id, :integer
  	add_index :pages, :site_id
  end

  def self.down
  	remove_column :pages, :site_id
  end
end
