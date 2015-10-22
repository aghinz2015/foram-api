class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username

  has_one :settings_set
end
