Page.rebuild!

Page.all.each{|page| page.update_attribute(:slug, page.slug.downcase) }

Page.find(340).self_and_descendants.each do |page|
  unless page.leaf? || page.class_name == 'ProductPage'
    if page.children.first.class_name == 'ProductPage'
      page.class_name = 'ProductListPage'
      page.layout = Layout.find_by_name('product_list')
    else
      page.class_name = 'ProductCategoriesPage'
      page.layout = Layout.find_by_name('product_categories')
    end
    
    page.save!
  end
    
    
  if page.class_name == 'ProductPage' && !page.parts.map(&:name).include?('perex') 
    page.parts.create(:name => 'perex', :content => '', :position => 99, :filter_id => 'CKEditor')
  end
end
