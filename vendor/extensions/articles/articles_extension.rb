# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ArticlesExtension < Radiant::Extension
  version "1.0"
  description "Extension for articles administration in backend and different frontend views"
  url "http://www.propeople.cz"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :news_entries
      admin.resources :news_tags
      admin.resources :news_categories
    end
  end
  
  def activate
    tab 'Content' do
      add_item 'Articles', '/admin/news_entries', :after => 'Pages'
    end
    
    Page.send :include,  NewsTags
  end
  
  def deactivate
  end
  
end
