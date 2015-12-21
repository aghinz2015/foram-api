class SettingsSetSerializer < ActiveModel::Serializer
  attributes :number_precision, :tree_level, :mappings
end
