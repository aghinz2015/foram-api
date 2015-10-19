class Users::SettingsSerializer < ActiveModel::Serializer
  attributes :number_precision, :mappings
end
