module CustomPageInterface
  def self.included(base)
    base.class_eval do
      before_filter :add_custom_page_creation_partials, :only => [:index]
      before_filter :add_specific_fields, :only => [:edit]   
      before_filter :load_languages, :only => [:index]
      

      include InstanceMethods     
      
      #alias_method_chain :new, :page_type
      
      
    	protected
    	
    	
    	def create_other_language_page(lang, main_page, multilingual_group, notify=true)
    		site = Site.find_by_language(lang.to_s)
  			if main_page.parent && main_page.parent.multilingual_group_id
  				lang_parent = Page.find_by_site_id_and_multilingual_group_id(site.id, main_page.parent.multilingual_group_id)
  			end
  			
  			lang_parent ||= site.homepage
  			
			  page = main_page.class_name.constantize.new		
  			page.site = site
  			page.parent = lang_parent
  			page.title = "[#{main_page.title}]"
  			page.breadcrumb = page.title
  			page.slug = "translate-#{main_page.slug}"
  			page.status = notify ? Status[:for_translation_notify] : Status[:for_traslation]
  			page.multilingual_group = multilingual_group
  			page.save!
  			
  			MultilingualMailer.deliver_translator_notification(page, lang) if notify
  		end 		
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

      #if self.model.respond_to?(:fields)
      #  @buttons_partials ||= []
      #  @buttons_partials << "specific_fields_box"  

      #  @fields = self.model.fields
      #  @field_columns = self.model.fields.class.columns_hash
      #end
    end
    
    def load_languages
      @sites = Site.all
    	@languages = YAML::load(Radiant::Config['multilingual.languages'])
   	end
   	
   	def precreate
      if params[:page_type].blank?
        self.model = model_class.new_with_defaults(config)
      else
        self.model = params[:page_type].constantize.new
        self.model.parent_id = params[:parent_id] if params[:parent_id]
      end

      if params[:parent_id].blank?
        self.model.slug = '/'
      end

      self.model.title = params[:page_title]
      slug = params[:page_title].fancy
      self.model.slug = slug

      i = 0
      while self.model.siblings.any? {|sibling| sibling.slug == self.model.slug }
        i += 1
        self.model.slug = slug + "-#{i}"
      end

      self.model.breadcrumb = params[:page_title]
      self.model.status ||= Status['draft']
      self.model.site = self.model.parent.site if self.model.parent
      self.model.layout ||= Layout.find_by_name("page")
      
      if params[:multilingual]
      	multilingual_group = MultilingualGroup.create
      	self.model.multilingual_group = multilingual_group
      	
      	params[:multilingual].each_pair do |lang, flags|
      		create_other_language_page(lang, self.model, multilingual_group, !flags[:notify].nil?) if flags[:create]			
      	end
      end
      
      self.model.save!

      redirect_to edit_admin_page_path(self.model)
    end
  end
end
