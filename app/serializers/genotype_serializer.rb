class GenotypeSerializer < ActiveModel::Serializer
  attributes :translation_factor,
             :growth_factor,
             :rotation_angle,
             :deviation_angle
end
