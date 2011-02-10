class NestedSetForPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :lft, :integer
    add_column :pages, :rgt, :integer
    
    execute "UPDATE pages SET lft = position"
    #Page.rebuild!
  end

  def self.down
    remove_column :pages, :lft
    remove_column :pages, :rgt
  end
end
