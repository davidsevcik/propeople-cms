module CustomPageInterface
  def self.included(base)
    base.class_eval do
      before_filter :add_custom_page_creation_partials, :only => [:index]
      before_filter :add_specific_fields, :only => [:edit]   
      before_filter :load_languages, :only => [:index, :edit]
      before_filter :add_translation_partial, :only => [:edit]
      
      include InstanceMethods     
 
    end
  end


  module InstanceMethods
    def add_custom_page_creation_partials
      include_javascript 'admin/modalbox'
      include_stylesheet 'admin/modalbox'
      include_javascript 'admin/custom_page'
      include_stylesheet 'admin/custom_page'
    end

    def add_specific_fields
      include_javascript 'admin/custom_page'
      include_stylesheet 'admin/custom_page'

      #if page.respond_to?(:fields)
      #  @buttons_partials ||= []
      #  @buttons_partials << "specific_fields_box"  

      #  @fields = page.fields
      #  @field_columns = page.fields.class.columns_hash
      #end
    end
    
    def load_languages
      @site = current_site
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
      slug = params[:page_title].fancy
      page.slug = slug

      i = 0
      while page.siblings.any? {|sibling| sibling.slug == page.slug }
        i += 1
        page.slug = slug + "-#{i}"
      end

      page.breadcrumb = params[:page_title]
      page.status ||= Status['draft']
      page.site = page.parent.site if page.parent
      page.layout ||= Layout.find_by_name("page")
      
      if params[:multilingual]
      	multilingual_group = MultilingualGroup.create
      	page.multilingual_group = multilingual_group
      	
      	params[:multilingual].each_pair do |lang, flags|
      		create_translation(lang, page, !flags[:notify].nil?) if flags[:create]			
      	end
      end
      
      page.save!

      redirect_to edit_admin_page_path(page)
    end
    
    
    def translate
      base_page = Page.find(params[:base_page_id])      
      translation = create_translation(params[:language], base_page)
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
			page.slug = "translate-#{base_page.slug}"
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
