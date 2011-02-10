require 'action_controller'
require 'action_controller/test_process.rb'


Page.find_all_by_class_name('ProductPage').each do |page| 
  page.attachments.each do |att|
    temp_file = att.temp_path || att.create_temp_file
    att.create_or_update_thumbnail(temp_file, 'product_perex', 'b70x90')
    temp_file = att.temp_path || att.create_temp_file
    att.create_or_update_thumbnail(temp_file, 'product_category', 'b179x133')
  end
end

Page.find_all_by_class_name('ProductCategoriesPage').each do |page|
  if product = page.descendants.detect {|desc| desc.class_name == 'ProductPage'}
    if attachment = product.attachments[0]
      file = ActionController::TestUploadedFile.new("public" + attachment.public_filename, attachment.content_type)
      page.attachments.create(:uploaded_data => file)
    end
  end
end
