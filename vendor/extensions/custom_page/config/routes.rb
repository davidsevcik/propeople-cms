ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :pages, :new => {:precreate => :post, :translate => :post}
  end
end
