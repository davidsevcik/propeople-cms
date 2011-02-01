require 'admin/pages_controller'

module PageFieldsExtension::PagesControllerExtensions
  def self.included(base)
    base.alias_method_chain :initialize_meta_rows_and_buttons, :page_fields
    base.class_eval {
      before_filter :add_page_fields_partials,
                    :only => [:edit, :new]
      include InstanceMethods
    }
  end
  
  def initialize_meta_rows_and_buttons_with_page_fields
    initialize_meta_rows_and_buttons_without_page_fields
    @meta.delete_if { |m| %w(keywords description).include? m[:field] }
    @meta.uniq!
  end
  
  module InstanceMethods
    def add_page_fields_partials
      include_stylesheet 'admin/page_fields'
    end
  end
  
  
end
