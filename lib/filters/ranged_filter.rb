module Filters::RangedFilter
  def ranged_attributes_scope(scope) # default scope = Foram.all
    conditions = {}
    self.attributes.select{ |k| k =~ /_m(ax|in)\z/ }.each do |(attribute, field, operator)|
      value = send(attribute)
      conditions.deep_merge!(field => { operator => value.to_f }) if value.present?
    end
    scope.where(conditions)
  end
end
