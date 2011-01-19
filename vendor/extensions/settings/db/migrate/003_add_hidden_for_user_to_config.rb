class AddIsHiddenForUserToConfig < ActiveRecord::Migration

  class Config < ActiveRecord::Base; end

  def self.up
    add_column :config, :is_hidden_for_user, :boolean, :default => false
  end

  def self.down
    remove_column :config, :is_hidden_for_user
  end
end