module Filters::BooleanFilter
  def boolean_attributes_scope(scope)
    conditions = {}
    self.attributes.select{ |k| k =~ /\Ais_/ }.each do |(name, field)|
      value = send(name)
      conditions.deep_merge!(field => value) if value.present?
    end
    scope.where(conditions)
  end
end
