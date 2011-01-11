 # Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class ShopExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/shop"
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate
    # tab 'Content' do
    #   add_item "Shop", "/admin/shop", :after => "Pages"
    # end

    SiteController.class_eval do
      before_filter :set_basket

      def set_basket
        Order.basket = Order.find(session[:order_id]) if session[:order_id]
      end
    end
  end
end
