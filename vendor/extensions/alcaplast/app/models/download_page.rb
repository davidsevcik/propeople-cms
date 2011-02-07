class DownloadPage < Page
  
  extended_page_type :name => 'Ke stažení'
  after_create :set_defaults
  

  private
  
  
  def set_defaults
    self.layout = Layout.find_by_name('download')
    self.save!
    parts.create(:name => 'nad_soubory', :content => '', :filter_id => 'CKEditor')
    parts.create(:name => 'pod_soubory', :content => '', :filter_id => 'CKEditor')
  end
end
