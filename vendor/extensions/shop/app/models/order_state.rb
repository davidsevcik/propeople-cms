class OrderState < ActiveRecord::Base
  has_many :orders, :class_name => "Order", :foreign_key => "state_id"
end
