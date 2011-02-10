class ProductPage < Page
  
  extended_page_type :name => 'Produkt'
  #before_create :set_defaults
  after_create :create_parts
  

  private
  
  def set_defaults
    
  end
  
  def create_parts
    self.layout = Layout.find_by_name('product')
    self.save!
    parts.create(:name => 'hlavni_popis', :content => '', :filter_id => 'CKEditor')
    parts.create(:name => 'podrobnosti', :title => 'Podrobnosti', :content => '', :filter_id => 'CKEditor')
    parts.create(:name => 'nahradni_dily', :title => 'Náhradní díly', :content => '', :filter_id => 'CKEditor')
    parts.create(:name => 'montaz', :title => 'Montáž', :content => '', :filter_id => 'CKEditor')
    parts.create(:name => 'video', :title => 'Video', :content => '', :filter_id => 'CKEditor')
    parts.create(:name => 'perex', :position => 99, :content => '', :filter_id => 'CKEditor')
  end
end
