class SettingsSetSerializer < ActiveModel::Serializer
  attributes :number_precision, :tree_level, :per_page, :mappings
end
