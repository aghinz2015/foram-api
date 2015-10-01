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
    def boolean_attribute(persistence_model, names)
      @boolean_attributes ||= []
      names.each_pair do |name, field|
        define_boolean_accessor(persistence_model, name)
        @boolean_attributes.push([name, field])
      end
    end

    def boolean_attributes
      @boolean_attributes
    end

    private

    def define_boolean_accessor(persistence_model, attribute)
      case persistence_model
      when :mongoid
        field attribute, type: Boolean
      when :normal
        attr_accessor attribute
      else
        raise ArgumentError, 'No persistence model provided'
      end
    end
  end
end
