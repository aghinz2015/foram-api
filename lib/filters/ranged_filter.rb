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
    def ranged_attribute(names)
      @ranged_attributes ||= []
      names.each_pair do |name, field|
        { "_min" => "$gte", "_max" => "$lte" }.each_pair do |suffix, operator|
          attribute = name.to_s + suffix
          attr_accessor attribute
          @ranged_attributes.push([attribute, field, operator])
        end
      end
    end

    def ranged_attributes
      @ranged_attributes
    end
  end
end
