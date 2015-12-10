module Filters::BooleanFilter
  def boolean_attributes_scope(scope)
    conditions = {}
    self.attributes.keys.select{ |k| k =~ /\Ais_/ }.each do |name|
      value = send(name)
      conditions.deep_merge!(name => value) if value.present?
    end
    scope.where(conditions)
  end
end
