module Filters::BooleanFilter
  def boolean_attributes_scope(scope)
    conditions = {}
    attributes_map = ForamFilter.attributes_map(scope)

    boolean_attributes.each do |name|
      value = send(name) rescue nil
      # TODO:0 think about how to cast to boolean
      value = value == 'true' ? true : false
      field = attributes_map[name]
      conditions.deep_merge!(field => value) unless value.nil?
    end
    scope.where(conditions)
  end

  private

  def boolean_attributes
    self.attributes.keys.select { |k| k =~ /\Ais_/ }
  end
end
