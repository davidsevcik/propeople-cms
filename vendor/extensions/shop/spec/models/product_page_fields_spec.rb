require File.dirname(__FILE__) + '/../spec_helper'

describe ProductPageFields do
  before(:each) do
    @product_page_fields = ProductPageFields.new
  end

  it "should be valid" do
    @product_page_fields.should be_valid
  end
end
