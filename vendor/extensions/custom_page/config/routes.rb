ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :pages, :new => {:precreate => :post}
  end
end
