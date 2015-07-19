module RangedFilter
  def self.included(base)
    base.extend(ClassMethods)
  end

  def ranged_attributes_scope(scope) # scope = Foram.all
    conditions = {}
    self.class.ranged_attribute_names.each do |name|
      ['_min', '_max'].each do |suffix|
        attribute = name.split('.').last + suffix
        if send(attribute).present?
          conditions.deep_merge!(number_condition(name, attribute))
        end
      end
    end
    scope.where(conditions)
  end

  def number_condition(name, attribute)
    operator = attribute =~ /_min\z/ ? '$gte' : '$lte'
    { "#{name.camelize(:lower)}": { operator => send(attribute) } }
  end

  module ClassMethods
    def ranged_attribute(names)
      @ranged_attribute_names = []
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
