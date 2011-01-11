require File.dirname(__FILE__) + '/../spec_helper'

describe OrderState do
  before(:each) do
    @order_state = OrderState.new
  end

  it "should be valid" do
    @order_state.should be_valid
  end
end
