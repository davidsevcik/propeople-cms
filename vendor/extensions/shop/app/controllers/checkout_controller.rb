class CheckoutController < SiteController
  radiant_layout 'page'
  no_login_required

  def new
    @order = Order.basket
  end


  def create
    Order.basket.state = OrderState.find_by_code('new')
    if Order.basket.update_attributes(params[:order])   
      ShopMailer.deliver_order_notification(Order.basket)
      session.delete(:order_id)
    else
      @order = Order.basket
      render :action => 'new'
    end
  end

end
