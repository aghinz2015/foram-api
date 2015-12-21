class SettingsSet
  include Mongoid::Document

  embedded_in :user

  field :number_precision,        type: Integer, default: 4
  field :tree_level,              type: Integer, default: 4
  field :mappings,                type: Hash,    default: {}

  validates_presence_of :number_precision, :tree_level
  validate :mappings_format

  private

  def mappings_format
    if mappings && mappings.keys.any?{ |k| k =~ /\W/ }
      errors.add(:mappings, 'format is invalid')
    end
  end
end
