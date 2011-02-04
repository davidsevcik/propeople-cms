require 'product_page_fields'

class ProductPage < Page
  
  extended_page_type :name => 'Produkt'
  before_create :set_defaults
  after_create :create_parts
  
  


  private
  
  def set_defaults
    self.layout = Layout.find_by_name('product')
    self.show_in_menu = false
  end
  
  def create_parts
    parts.create(:name => 'hlavni_popis', :content => '', :filter_id => 'CKEditor')
    parts.create(:name => 'podrobnosti', :title => 'Podrobnosti' :content => '', :filter_id => 'CKEditor')
    parts.create(:name => 'podrobnosti', :content => '', :filter_id => 'CKEditor')
  end
end
