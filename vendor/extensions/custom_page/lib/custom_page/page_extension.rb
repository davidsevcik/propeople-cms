module CustomPage
  module PageExtension    
    def self.included(base)
      base.class_eval do

        def self.extended_page_type(options={})
          options.reverse_merge!(:for_editor => true)

          display_name(options[:name]) unless options[:name].nil?

          unless options[:fields_class].nil?
            fields_class = options[:fields_class].constantize
            if fields_class.table_exists?
              has_one :fields, :class_name => options[:fields_class], :foreign_key => 'page_id', :dependent => :delete

              after_create :create_fields
              after_update {|record| record.fields.save }

              fields_class.columns.each do |col|
                unless %w{id page_id}.include?(col.name)
                  define_method col.name do
                    fields.send(col.name)
                  end

                  define_method "#{col.name}=" do |value|
                    fields.send("#{col.name}=", value)
                  end

                  tag col.name do |tag|
                    tag.locals.page.send(col.name)
                  end
                end
              end
            end
          end

          @is_type_for_editor = options[:for_editor]
        end


        def self.type_for_editor?
          @is_type_for_editor ||= false
        end
      end
    end

  end
end
