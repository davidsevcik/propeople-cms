ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :pages, :collection => {:precreate => :post}, :member => {:translate_page => :post}
  end
end
