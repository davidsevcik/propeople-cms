# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class SiteExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/site"
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate

    Page.send :include, SiteTags
    ApplicationHelper.module_eval do
      def meta_label
        meta_errors? ? 'Méně' : 'Více'
      end
    end

    ArchiveIndexTagsAndMethods.module_eval do
      tag "title" do |tag|
        setup_date_parts
        page = tag.locals.page
        unless @year.nil?
          I18n.l(Date.new((@year || 1).to_i, (@month || 1).to_i, (@day || 1).to_i), :format => page.title)
        else
          page.title
        end
      end
    end

    ConditionalTags::CustomElement.send :include, SiteEvaluators

#    Admin::PagesController.class_eval do
#      before_filter :add_custom_admin_assets, :only => [:edit, :new]
#
#      def add_custom_admin_assets
#        include_stylesheet 'admin/custom_admin'
#      end
#    end
  end
end
