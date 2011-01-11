ActionController::Routing::Routes.draw do |map|
  # map.namespace :admin, :member => { :remove => :get } do |admin|
  #   admin.resources :shop
  # end

  map.basket 'basket', :controller => 'basket', :action => 'show'
  map.add_to_basket 'basket/add', :controller => 'basket', :action => 'add_product'
  map.update_basket 'basket/update', :controller => 'basket', :action => 'update'
  map.new_checkout 'checkout', :controller => 'checkout', :action => 'new'
  map.create_checkout 'checkout/finished', :controller => 'checkout', :action => 'create'
end