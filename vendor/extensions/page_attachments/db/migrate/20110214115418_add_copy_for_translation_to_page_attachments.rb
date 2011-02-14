class AddCopyForTranslationToPageAttachments < ActiveRecord::Migration
  def self.up
    add_column :page_attachments, :copy_to_translation, :boolean, :default => true
  end

  def self.down
    remove_column :page_attachments, :copy_to_translation
  end
end
