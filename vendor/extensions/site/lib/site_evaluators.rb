module SiteEvaluators
  include ConditionalTags::Evaluatable

  evaluator 'extensions', :index_not_permitted do |tag, elm_info|
    Radiant::Extension.descendants.map {|c| c.name.sub!(/Extension/, '').underscore }
  end
end