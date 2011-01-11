module ShopTags

  include Radiant::Taggable

  tag 'basket' do |tag|
    if Order.current
      tag.locals.order_items = Order.basket.items
      tag.expand
    else
      '<p>Košík je prázdný</p>'
    end
  end


  tag 'basket:items' do |tag|
    result = []
    Order.basket.items.each_with_index do |item, i|
      tag.locals.child = item
      tag.locals.page = item
      result << tag.expand
    end
    result
  end
end