module CustomPageInterface
  def self.included(base)
    base.class_eval do
      before_filter :add_custom_page_partials, :only => [:index, :edit]
      before_filter :load_languages, :only => [:index, :edit]
      before_filter :add_translation_partial, :only => [:edit]
      
      include InstanceMethods     
 
    end
  end


  module InstanceMethods
    def add_custom_page_partials
      include_javascript 'admin/modalbox'
      include_stylesheet 'admin/modalbox'
      include_javascript 'admin/custom_page'
      include_stylesheet 'admin/custom_page'
    end

    
    def load_languages
      @sites = Site.all
    	@languages = YAML::load(Radiant::Config['multilingual.languages'])
   	end
   	
   	
   	def precreate
      if params[:page_type].blank?
        page = model_class.new_with_defaults(config)
      else
        page = params[:page_type].constantize.new
        page.parent_id = params[:parent_id] if params[:parent_id]
      end

      if params[:parent_id].blank?
        page.slug = '/'
      end

      page.title = params[:page_title]
      page.auto_slug
      page.breadcrumb = params[:page_title]
      page.status ||= Status['draft']
      page.site = page.parent.site if page.parent
      page.layout ||= Layout.find_by_name("page")
      page.create_multilingual_group 
      page.save!
      
      if params[:multilingual]
      	params[:multilingual].each_pair do |lang, flags|
      		create_translation(lang, page, !flags[:notify].nil?) if flags[:create]			
      	end
      end     

      redirect_to edit_admin_page_path(page)
    end
    
    
    def translate_page
      base_page = Page.find(params[:id])      
      translation = create_translation(params[:language], base_page)
      change_site(translation.site)
      redirect_to edit_admin_page_path(translation)
    end
   
   
   
  protected 	
    	
  	def create_translation(lang, base_page, notify=true)
  		site = Site.find_by_language(lang.to_s)
			if base_page.parent && base_page.parent.multilingual_group_id
				lang_parent = Page.find_by_site_id_and_multilingual_group_id(site.id, base_page.parent.multilingual_group_id)
			end
			
			lang_parent ||= site.homepage
			
		  page = base_page.class_name.constantize.new		
			page.site = site
			page.parent = lang_parent
			page.title = "[#{base_page.title}]"
			page.breadcrumb = page.title
			page.slug = "translate-#{base_page.id}-#{lang}"
			page.status = notify ? Status[:for_translation_notify] : Status[:for_traslation]
			page.multilingual_group_id = base_page.multilingual_group_id
			page.save!
			MultilingualMailer.deliver_translator_notification(page, lang) if notify
			
			return page
		end 		
		
		
		
		def add_translation_partial
		  @buttons_partials ||= []
      @buttons_partials << "translations_box"
		end
  end
end
