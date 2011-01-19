ActionController::Routing::Routes.draw do |map|
    map.namespace :admin,
                  :controller => 'text_assets',
                  :member => { :remove => :get },
                  :collection => { :upload => :post } do |admin|
      
      admin.resources :stylesheets, :as => 'css', :requirements => { :asset_type => 'stylesheet'}, :conditions => {:upload => :post}
      admin.resources :javascripts, :as => 'js', :requirements => { :asset_type => 'javascript' }, :conditions => {:upload => :post}
    end
end