module CustomPageInterface
  def self.included(base)
    base.class_eval do
      before_filter :add_custom_page_creation_partials, :only => [:index]
      before_filter :add_specific_fields, :only => [:edit]      

      include InstanceMethods

      def new
        if params[:page_type].blank?
          self.model = model_class.new_with_defaults(config)
        else
          self.model = params[:page_type].constantize.new
          self.model.parent_id = params[:page_id]
        end

        if params[:page_id].blank?
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
        self.model.status = Status['draft']
        self.model.class_name = params[:page_type]
        self.model.save!

        redirect_to edit_admin_page_path(self.model)
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

      if self.model.respond_to?(:fields)
        @buttons_partials ||= []
        @buttons_partials << "specific_fields_box"   

        @fields = self.model.fields
        @field_columns = self.model.fields.class.columns_hash
      end
    end
  end
end
