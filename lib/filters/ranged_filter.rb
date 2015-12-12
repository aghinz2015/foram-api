module Filters::RangedFilter
  def ranged_attributes_scope(scope) # default scope = Foram.all
    conditions = {}
    attributes_map = ForamFilter.attributes_map(scope)

    ranged_attributes.each do |attribute|
      operator = attribute.match(/.*_(max|min)\z/)[1] == 'max' ? '$lte' : '$gte'
      value = send(attribute) rescue nil
      field = attributes_map[attribute]
      conditions.deep_merge!(field => { operator => value.to_f }) if value.present?
    end
    scope.where(conditions)
  end

  def ranged_attributes
    self.attributes.keys.select { |k| k =~ /_m(ax|in)\z/ }
  end
end
