class AddHiddenToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :sites, :hidden
  end
end
