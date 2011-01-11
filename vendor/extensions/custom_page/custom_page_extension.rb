# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

require 'vendor/plugins/fancy_string/init'

class CustomPageExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/custom_page"
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate
    Admin::PagesController.send :include, CustomPageInterface
    Page.send :include, CustomPage::PageExtension
    Page.send :include, CustomPage::Tags

    admin.page.index.add :bottom, 'new_page_form'
    admin.page.edit.add :layout_row, "published_at_select"
    admin.page.edit.add :layout_row, "show_in_menu"
  end
end
