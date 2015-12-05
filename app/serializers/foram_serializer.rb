class ForamSerializer < ActiveModel::Serializer
  def attributes
    object.attributes.deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end
end
