class ShopMailer < ActionMailer::Base

  def order_notification(order)
    from order.email
    recipients Radiant::Config['web.email']
    subject "Nová objednávka na #{Radiant::Config['web.domena']}"
    content_type "text/html"
    body(:order => order)
  end
end
