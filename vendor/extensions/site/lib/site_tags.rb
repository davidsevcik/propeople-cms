module SiteTags
  include Radiant::Taggable

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
end