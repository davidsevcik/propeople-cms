class ProductListPage < Page
  
  extended_page_type :name => 'Výpis produktů'
  after_create :set_defaults
  

  private
  
  
  def set_defaults
    self.layout = Layout.find_by_name('product_categories')
    self.save!
    parts.create(:name => 'text_nad', :content => '', :filter_id => 'CKEditor')
    parts.create(:name => 'text_pod', :content => '', :filter_id => 'CKEditor')
  end
end
