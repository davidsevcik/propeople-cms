class AddRedirectToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :redirect, :string
  end

  def self.down
    remove_column :pages, :redirect
  end
end
