module Filters::BooleanFilter
  def boolean_attributes_scope(scope)
    conditions = {}
    attributes_map = ForamFilter.attributes_map(scope)

    self.attributes.keys.select{ |k| send(k).class == FalseClass || send(k).class == TrueClass }.each do |name|
      value = send(name) rescue nil
      field = attributes_map[name]
      conditions.deep_merge!(field => value) unless value.nil?
    end
    scope.where(conditions)
  end
end
