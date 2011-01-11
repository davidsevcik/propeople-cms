module Multilingual::PageExtension
  def self.included(base)
    base.class_eval do
			before_update :create_translations
    end
    
    base.extend ClassMethods
  end
  
  module ClassMethods
    def create_translations
    	if self.multilingual_group.nil? && self.status == Status[:published]
    		self.multilingual_group = Page.maximum(:multilingual_group) + 1
    	end
    end
  end
  
end
