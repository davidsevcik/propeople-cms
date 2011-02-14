require_dependency 'application_controller'
# require File.dirname(__FILE__) + '/lib/geometry'
# require 'tempfile'

class PageAttachmentsExtension < Radiant::Extension
  version "1.0.2"
  description "Adds page-attachment-style asset management."
  url "http://radiantcms.org"
  
  extension_config do |config|
    config.gem 'will_paginate'
  end

  def activate
    if self.respond_to?(:tab)
      tab "Settings" do
        add_item 'Attachments', "/admin/page_attachments"
      end
    else
      admin.tabs.add 'Attachments', '/admin/page_attachments', :after => "Layouts", :visibility => [:admin]
    end
    # Regular page attachments stuff
    Page.class_eval {
      include PageAttachmentAssociations
      include PageAttachmentTags
    }
    UserActionObserver.instance.send :add_observer!, PageAttachment
    Admin::PagesController.send :include, PageAttachmentsInterface
  end

  def deactivate
  end

end
