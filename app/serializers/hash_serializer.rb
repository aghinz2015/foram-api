class HashSerializer < ActiveModel::Serializer
  def attributes
    object.deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end
end
