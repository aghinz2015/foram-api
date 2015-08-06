class ForamSerializer < ActiveModel::Serializer
  attribute :id

  has_one :genotype
end
