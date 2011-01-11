require File.dirname(__FILE__) + '/../spec_helper'

describe ProductPage do
  before(:each) do
    @product_page = ProductPage.new
  end

  it "should be valid" do
    @product_page.should be_valid
  end
end
