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
   	
   	
   	protect_from_forgery :except => [:precreate, :translate_page] 
   	
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
      		page.create_translation(lang, !flags[:notify].nil?) if flags[:create]			
      	end
      end     

      redirect_to edit_admin_page_path(page)
    end
      
    
    def translate_page
      base_page = Page.find(params[:id])      
      translation = base_page.create_translation(params[:language])
      change_site(translation.site)
      redirect_to edit_admin_page_path(translation)
    end
   
   
   
  protected 	
		
		
		def add_translation_partial
		  @buttons_partials ||= []
      @buttons_partials << "translations_box"
		end
  end
end
