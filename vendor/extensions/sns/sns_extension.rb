require_dependency 'application_controller'
require 'ostruct'

class SnsExtension < Radiant::Extension
  version "#{File.read(File.expand_path(File.dirname(__FILE__)) + '/VERSION')}"
  extension_name "Styles 'n Scripts"
  description "Adds CSS and JS file management to Radiant"
  url "http://github.com/radiant/radiant-sns-extension"

  def activate
    tab "Design" do
      add_item 'CSS', '/admin/css'
      add_item 'JS', '/admin/js'
    end
    
    # Include my mixins (extending PageTags and SiteController)
    Page.send :include, Sns::PageTags
    SiteController.send :include, Sns::SiteControllerExt

    Radiant::AdminUI.class_eval do
      attr_accessor :text_assets
    end
    admin.text_assets = load_default_text_assets_regions

    # Add Javascript and Stylesheet to UserActionObserver (used for created_by and updated_by)
    UserActionObserver.instance.send :add_observer!, Stylesheet
    UserActionObserver.instance.send :add_observer!, Javascript
  end


  def deactivate

  end


  private

    # Defines this extension's default regions (so that we can incorporate shards
    # into its views).
    def load_default_text_assets_regions
      returning OpenStruct.new do |text_asset|
        text_asset.index = Radiant::AdminUI::RegionSet.new do |index|
          index.top.concat %w{}
        end
        text_asset.edit = Radiant::AdminUI::RegionSet.new do |edit|
          edit.main.concat %w{edit_header edit_form}
          edit.form.concat %w{edit_title edit_content edit_timestamp}
          edit.content_bottom.concat %w{edit_filter}
          edit.form_bottom.concat %w{edit_buttons}
        end
        text_asset.new = text_asset.edit
      end
    end
end