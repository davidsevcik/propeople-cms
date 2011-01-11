module CustomPage
  module Tags
    include Radiant::Taggable

    class TagError < StandardError; end

    desc %{
      Write the value of page field.

      *Usage*:

      <pre><code><r:field name="price" /></code></pre>
    }
    tag "field" do |tag|
      raise TagError, "'name' attribute required" unless name = tag.attr['name']
      page = tag.locals.page
      page.fields.send(name)
    end
    
  end
end
