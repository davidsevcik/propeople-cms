class NormalPage < Page

  extended_page_type :name => 'Stránka'
  before_create :set_layout
  after_create :set_parts


  private

	def set_layout
		self.layout = Layout.find_by_name('page')
	end

  def set_parts
    parts.create(:name => 'text', :content => '', :filter_id => 'CKEditor')
  end
end
