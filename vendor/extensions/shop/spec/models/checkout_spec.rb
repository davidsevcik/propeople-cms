require File.dirname(__FILE__) + '/../spec_helper'

describe Checkout do
  before(:each) do
    @checkout = Checkout.new
  end

  it "should be valid" do
    @checkout.should be_valid
  end
end
