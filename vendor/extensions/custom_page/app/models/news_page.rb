class NewsPage < Page

  extended_page_type :name => 'Aktualita'
  after_create :set_defaults


  private


  def set_defaults
    self.layout = Layout.find_by_name('news_entry')
    self.show_in_menu = false
    self.save!
    parts.create(:name => 'text', :content => '', :filter_id => 'Fckeditor')
    parts.create(:name => 'shrnuti', :content => '')
  end
end