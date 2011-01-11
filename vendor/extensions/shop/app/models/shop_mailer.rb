class ShopMailer < ActionMailer::Base

  def order_notification(order)
    recipients Radiant::Config['web.email']
    subject "Nová objednávka na #{Radiant::Config['web.domena']}"
    body(:order => order)
  end
end