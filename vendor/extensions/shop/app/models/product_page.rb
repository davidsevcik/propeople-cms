require 'product_page_fields'

class ProductPage < Page
  
  extended_page_type :name => 'Produkt', :fields_class => 'ProductPageFields'
  after_create :set_defaults


  private
  
  def set_defaults
    self.layout = Layout.find_by_name('product')
    self.show_in_menu = false
    self.save!
    parts.create(:name => 'popis', :content => '', :filter_id => 'Fckeditor')
    parts.create(:name => 'kratky_popis', :content => '')
  end
end
