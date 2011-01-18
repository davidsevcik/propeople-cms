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

    #ArchiveIndexTagsAndMethods.module_eval do
    #  tag "title" do |tag|
    #    setup_date_parts
    #    page = tag.locals.page
    #    unless @year.nil?
    #      I18n.l(Date.new((@year || 1).to_i, (@month || 1).to_i, (@day || 1).to_i), :format => page.title)
    #    else
    #      page.title
    #    end
    #  end
    #end

    ConditionalTags::CustomElement.send :include, SiteEvaluators
    
    
    Status.class_eval do
    	class << self
    		@@loaded_statuses = []
    	
    		def [](value)
    			status = @@loaded_statuses.find {|st| st.symbol == value.to_s.downcase.intern }
    			unless status
						statuses = YAML::load(Radiant::Config['page.statuses']).invert
						status = Status.new(:id => statuses[value.to_s].to_i, :name => value.to_s.capitalize)
						@@loaded_statuses << status
					end
					status
				end
				
				def find(id)
					status = @@loaded_statuses.find {|st| st.id == id.to_i }
					unless status
						statuses = YAML::load(Radiant::Config['page.statuses'])
						if statuses.has_key?(id.to_i)
							status = Status.new(:id => id.to_i, :name => statuses[id.to_i].capitalize)
							@@loaded_statuses << status
						else
							raise ActiveRecord::RecordNotFound.new("#{id} not found")
						end
					end					
					status
				end
		
				def find_all
					statuses = YAML::load(Radiant::Config['page.statuses'])
					statuses.each_pair do |id, name|
						unless @@loaded_statuses.find {|st| st.id == id.to_i }
							@@loaded_statuses << Status.new(:id => id.to_i, :name => name.capitalize)
						end
					end
					@@loaded_statuses.dup
				end  
				
    	end
    end

#    Admin::PagesController.class_eval do
#      before_filter :add_custom_admin_assets, :only => [:edit, :new]
#
#      def add_custom_admin_assets
#        include_stylesheet 'admin/custom_admin'
#      end
#    end
  end
end
