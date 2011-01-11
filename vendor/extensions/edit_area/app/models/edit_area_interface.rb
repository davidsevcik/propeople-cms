module EditAreaInterface
  def self.included(base)
    base.class_eval {
      before_filter :add_edit_area, :only => [:edit, :new]
      include InstanceMethods
    }
  end

  module InstanceMethods
    def add_edit_area
      include_javascript 'admin/edit_area/edit_area_full.js'
      include_javascript 'admin/edit_area_setup.js'
    end
  end
end
