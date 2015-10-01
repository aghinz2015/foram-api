module Filters::RangedFilter
  def self.included(base)
    base.extend(ClassMethods)
  end

  def ranged_attributes_scope(scope) # default scope = Foram.all
    conditions = {}
    self.class.ranged_attributes.each do |(attribute, field, operator)|
      value = send(attribute)
      conditions.deep_merge!(field => { operator => value.to_f }) if value.present?
    end
    scope.where(conditions)
  end

  module ClassMethods
    def ranged_attribute(persistence_model, names)
      @ranged_attributes ||= []
      names.each_pair do |name, field|
        { '_min' => '$gte', '_max' => '$lte' }.each_pair do |suffix, operator|
          attribute = name.to_s + suffix
          define_ranged_accessor(persistence_model, attribute)
          @ranged_attributes.push([attribute.to_sym, field, operator])
        end
      end
    end

    def ranged_attributes
      @ranged_attributes
    end

    private

    def define_ranged_accessor(persistence_model, attribute)
      case persistence_model
      when :mongoid
        field attribute, type: Float
      when :normal
        attr_accessor attribute
      else
        raise ArgumentError, 'No persistence model provided'
      end
    end
  end
end
