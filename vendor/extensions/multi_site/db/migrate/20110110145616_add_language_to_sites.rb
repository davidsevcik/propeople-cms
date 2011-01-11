class AddLanguageToSites < ActiveRecord::Migration
  def self.up
  	add_column :sites, :language, :string
  end

  def self.down
  	remove_column :sites, :language
  end
end
