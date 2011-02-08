module AlcaplastTags
  include Radiant::Taggable

  class TagError < StandardError; end

  # don't remove the comment below, it's used by README.erb
  # ruby
  desc %{
    Custom subnavigation for alcaplast website.
  }
  tag "alcaplast_subnav" do |tag|
    tag.render('nav', {'root' => tag.locals.page.ancestors[-2].url, 'expand_all' => true, 'depth' => 10, 'id' => 'subnav'})
  end
  
end
