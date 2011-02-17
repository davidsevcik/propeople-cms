class AddSystemNameToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :system_name, :string
  end

  def self.down
    remove_column :pages, :system_name
  end
end
