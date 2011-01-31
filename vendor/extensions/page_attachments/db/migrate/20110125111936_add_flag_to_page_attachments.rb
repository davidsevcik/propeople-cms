class AddFlagToPageAttachments < ActiveRecord::Migration
  def self.up
    add_column :page_attachments, :flag, :string
  end

  def self.down
    remove_column :page_attachments, :flag
  end
end
