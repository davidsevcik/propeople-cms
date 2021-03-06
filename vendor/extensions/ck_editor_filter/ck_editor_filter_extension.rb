# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class CkEditorFilterExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/ck_editor_filter"
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources :attachments
    end
  end
  
  def activate
    CkEditorFilter
    Admin::PagesController.send :include, CkeditorInterface
    admin.page.edit.add :part_controls, "admin/page_parts/editor_control"
  end
  
  def deactivate
    # admin.tabs.remove "Ck Editor Filter"
  end
  
end
