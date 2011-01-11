class Order < ActiveRecord::Base
  belongs_to :state, :class_name => "OrderState", :foreign_key => "state_id"
  has_many :items, :class_name => "OrderItem", :foreign_key => "order_id"

  cattr_accessor :basket

  validates_presence_of :name, :surname, :email, :phone, :street, :city, :zip,
                        :unless => Proc.new {|order| order.state_id.nil? },
                        :message => 'Musí být zadáno'
end
