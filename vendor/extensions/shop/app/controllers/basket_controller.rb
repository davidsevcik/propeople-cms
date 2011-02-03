class BasketController < SiteController
  radiant_layout 'basket'
  no_login_required


  def show
    @items = Order.basket.try(:items)
  end

  
  def add_product
    if Order.basket.nil?
      Order.basket = Order.create
      session[:order_id] = Order.basket.id
    end
    product_page = ProductPage.find(params[:id])
    if item = Order.basket.items.find_by_product_page_id(params[:id])
      item.update_attribute(:quantity, item.quantity + 1) 
    else
      Order.basket.items.create(:product_page_id => product_page.id, :price => product_page.price)
    end

    redirect_to :action => 'show'
  end


  def update
    if Order.basket
      Order.basket.items.clear
      if params[:items]

        params[:items].values.each do |item|
          if item[:quantity] =~ /^[1-9]\d*$/
            product_page = ProductPage.find(item[:product_page_id])
            Order.basket.items.create(:product_page_id => product_page.id, :price => product_page.price, :quantity => item[:quantity])
          end
        end
      end
    end

    redirect_to :action => 'show'
  end

end
