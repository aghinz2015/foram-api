module Filters::BooleanFilter
  def self.included(base)
    base.extend(ClassMethods)
  end

  def boolean_attributes_scope(scope)
    conditions = {}
    self.class.boolean_attributes.each do |(name, field)|
      value = send(name)
      conditions.deep_merge!(field => value) if value.present?
    end
    scope.where(conditions)
  end

  module ClassMethods
    def boolean_attribute(names)
      @boolean_attributes ||= []
      names.each_pair do |name, field|
        attr_accessor name
        @boolean_attributes.push([name, field])
      end
    end

    def boolean_attributes
      @boolean_attributes
    end
  end
end
