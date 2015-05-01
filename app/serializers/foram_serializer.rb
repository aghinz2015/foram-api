class ForamSerializer < ActiveModel::Serializer
  attributes :id, :kx, :ky, :kz, :tf, :phi, :beta
end
