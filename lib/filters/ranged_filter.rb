module RangedFilter
  def self.included(base)
    base.extend(ClassMethods)
  end

  def ranged_attributes_scope(scope) # default scope = Foram.all
    conditions = {}
    self.class.ranged_attribute_names.each do |name|
      { "_min" => "$gte", "_max" => "$lte" }.each_pair do |suffix, operator|
        attribute = name.split('.').last + suffix
        if send(attribute).present?
          conditions.deep_merge!("#{name.camelize(:lower)}": { operator => send(attribute) })
        end
      end
    end
    scope.where(conditions)
  end

  module ClassMethods
    def ranged_attribute(names)
      @ranged_attribute_names ||= []
      names.each do |name|
        ['_min', '_max'].each do |suffix|
          attr_accessor name.split('.').last + suffix
          @ranged_attribute_names.push(name)
        end
      end
    end

    def ranged_attribute_names
      @ranged_attribute_names
    end
  end
end
