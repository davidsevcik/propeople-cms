ActionController::Routing::Routes.draw do |map|
  # map.namespace :admin, :member => { :remove => :get } do |admin|
  #   admin.resources :site
  # end
  
  map.connect 'export_pdf/:id', :controller => 'site', :action => 'export_pdf'
end
