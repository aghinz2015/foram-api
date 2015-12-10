class ForamSerializer < ActiveModel::Serializer
  def attributes
    object.attributes[:genotype].each { |k, v| object.attributes[:genotype][k] = demongoize(v) }
    object.attributes.deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end

  def demongoize(value)
    return unless value.is_a? Array
    {
      effective: value[0],
      first_set: value[1],
      second_set: value[2]
    }
  end
end
