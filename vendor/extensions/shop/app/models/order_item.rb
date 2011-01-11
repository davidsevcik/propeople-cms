class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product, :class_name => "ProductPage", :foreign_key => "product_page_id"
end
