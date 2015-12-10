module Filters::RangedFilter
  def ranged_attributes_scope(scope) # default scope = Foram.all
    conditions = {}
    self.attributes.keys.select{ |k| k =~ /_m(ax|in)\z/ }.each do |attribute|
      match = attribute.match(/(.*)_(max|min)\z/)
      field = match[1]
      operator = match[2] == 'max' ? '$lte' : '$gte'
      value = send(attribute)
      conditions.deep_merge!(field => { operator => value.to_f }) if value.present?
    end
    scope.where(conditions)
  end
end
