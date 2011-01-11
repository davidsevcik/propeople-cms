# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class EditAreaExtension < Radiant::Extension
  version "1.0"
  description "Replaces textareas with the EditArea."
  url "https://noweb.com/"
  
  def activate
    Admin::LayoutsController.send :include, EditAreaInterface
    Admin::SnippetsController.send :include, EditAreaInterface
    Admin::TextAssetsController.send :include, EditAreaInterface
  end
end