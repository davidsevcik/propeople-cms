module SiteTags
  include Radiant::Taggable
  include ActionView::Helpers::TagHelper
  
  class TagError < StandardError; end

  tag 'if_blank' do |tag|
    part_name = tag_part_name(tag)
    parts_arr = part_name.split(',')
    inherit = boolean_attr_or_error(tag, 'inherit', false)
    find = attr_or_error(tag, :attribute_name => 'find', :default => 'all', :values => 'any, all')
    expandable, all_found = true, true
    parts_arr.each do |name|
      part_page = tag.locals.page
      name.strip!
      if inherit
        while (part_page.part(name).nil? and (not part_page.parent.nil?)) do
          part_page = part_page.parent
        end
      end
      expandable = false if !part_page.part(name).nil? && !part_page.part(name).content.strip.empty?
      all_found = false if part_page.part(name).nil? || part_page.part(name).content.strip.empty?
    end
    if all_found == false and find == 'all'
      expandable = true
    end
    tag.expand if expandable
  end


  tag 'unless_blank' do |tag|
    part_name = tag_part_name(tag)
    parts_arr = part_name.split(',')
    inherit = boolean_attr_or_error(tag, 'inherit', 'false')
    find = attr_or_error(tag, :attribute_name => 'find', :default => 'all', :values => 'any, all')
    expandable = true
    one_found = false
    parts_arr.each do |name|
      part_page = tag.locals.page
      name.strip!
      if inherit
        while (part_page.part(name).nil? and (not part_page.parent.nil?)) do
          part_page = part_page.parent
        end
      end
      expandable = false if part_page.part(name).nil? || part_page.part(name).content.strip.empty?
      one_found ||= true if !part_page.part(name).nil? && !part_page.part(name).content.strip.empty?
    end
    expandable = true if (find == 'any' and one_found)
    tag.expand if expandable
  end

  tag 'local_date' do |tag|
    page = tag.locals.page
    format = (tag.attr['format'] || '%A, %B %d, %Y')
    time_attr = tag.attr['for']
    date = if time_attr
      case
      when time_attr == 'now'
        Time.zone.now
      when ['published_at', 'created_at', 'updated_at'].include?(time_attr)
        page[time_attr]
      else
        raise TagError, "Invalid value for 'for' attribute."
      end
    else
      page.published_at || page.created_at
    end
    I18n.l date, :format => format
  end

  tag "attachment:if_description" do |tag|
    raise TagError, "'name' attribute required" unless name = tag.attr['name'] or tag.locals.attachment
    page = tag.locals.page
    attachment = tag.locals.attachment || page.attachment(name)
    tag.expand unless attachment.attributes['description'].blank?
  end

  tag 'page_id' do |tag|
    tag.locals.page.id
  end
  
  tag 'url' do |tag|
    tag.locals.page.url
  end


  tag 'homepage_grid' do |tag|
    page = tag.locals.page
    grid = {}

    page.parts.each do |part|
      if part.name =~ /cell_(\d+)_(\d+)/
        row = $1.to_i
        col = $2.to_i
        grid[row] = {} unless grid.has_key?(row)
        grid[row][col] = part
      end
    end

    first_row = true
    result = []
    grid = grid.sort

    grid.each do |row|
      cols = row[1].sort

      if first_row
        first_row = false
      else
        result << '<hr />'
      end

      col_index = 4 - cols.size

      distribution = case col_index
                       when 3 then {3 => '100%'}
                       when 2 then {2 => '40%', 3 => '60%'}
                       else nil
                     end

      cols.each do |col|
        part = col[1]
        div = '<div class="col' + col_index.to_s + '-wrap"'
        div += ' style="width:' + distribution[col_index] + '"' if distribution
        result << div + '>'
        result << '<div class="col' + col_index.to_s + '">'
        result << tag.globals.page.render_snippet(part)
        result << '</div>'
        result << '</div>'
        col_index += 1
      end
    end

    result.join("\n")
  end
  
  
  
  tag "nested_menu" do |tag|
    
    %w{relative include_root show_all}.each do |prop|
      eval "@#{prop} = tag.attr.delete('#{prop}') == 'true' ? true : false"
    end
  
    @depth = tag.attr.delete('depth')
    @depth = @depth && @depth.to_i
    
    @root_id = tag.attr.delete('root_id')
    
    if @root_id
      @root = Page.find(@root_id) 
    else
      @root = @relative ? tag.locals.page : Page.current_site.homepage
    end
    
    
    min_level = @root.level
    @depth += @root.level if @depth   
     
    unless @include_root
      min_level += 1
      @depth += 1 if @depth
    end 
    
    last_level = min_level
    tree = ''
    
    if @all_pages.nil?
      homepage = Page.respond_to?(:current_site) ? Page.current_site.homepage : Page.root
      @all_pages = homepage.self_and_descendants
    end       
    
    Page.each_with_level(@all_pages) do |page, level|  
      if page.left >= @root.left && page.right <= @root.right &&
          level >= min_level && (!@depth || level < @depth) &&  
          (@show_all || page.show_in_menu?) && 
          !page.virtual? && page.published? && !page.part("no-map")
        
          
        level_diff = level - last_level    
        
        if level_diff == 0
          tree += "</li>\n"
        elsif level_diff == 1
          tree += "<ul>\n"
        elsif level_diff < 0
          tree += "</li>\n" + ("</ul>\n</li>\n" * level_diff.abs)
        end
           
        tree += "<li#{page == tag.locals.page ? ' class="current"' : ''}><a href=\"#{page.url}\">#{h(page.breadcrumb)}</a>" 
        last_level = level
      end
    end
    
    
    if tag.attr
      html_options = tag.attr.stringify_keys
      tag_options = tag_options(html_options)
    else
      tag_options = ''
    end
    
    %{<ul#{tag_options}>
    #{tree}
    </ul>}
  end
  
  
  desc %{
    Inside this tag all page related tags refer to the page found at the @url@ attribute.
    @url@s may be relative or absolute paths.

    *Usage:*

    <pre><code><r:find url="value_to_find" system_name="name">...</r:find></code></pre>
  }
  tag 'find' do |tag|
    url = tag.attr['url']
    sys_name = tag.attr['system_name']
    raise TagError.new("`find' tag must contain `url' or `system_name' attribute") if url.blank? && sys_name.blank?

    if url
      found = Page.find_by_url(absolute_path_for(tag.locals.page.url, url))
    else # sys_name
      conditions = {:system_name => sys_name}
      conditions[:site_id] = Page.current_site.id if Page.respond_to?(:current_site)
      found = Page.first(:conditions => conditions)
    end
      
    if page_found?(found)
      tag.locals.page = found
      tag.expand
    end
  end

end
