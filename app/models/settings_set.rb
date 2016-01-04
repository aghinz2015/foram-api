class SettingsSet
  include Mongoid::Document

  embedded_in :user

  field :number_precision,        type: Integer, default: 4
  field :tree_level,              type: Integer, default: 4
  field :per_page,                type: Integer, default: 20
  field :mappings,                type: Hash,    default: {}

  validates :number_precision, :tree_level, :per_page, presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validate :mappings_format

  private

  def mappings_format
    if mappings && mappings.keys.any?{ |k| k =~ /\W/ }
      errors.add(:mappings, 'format is invalid')
    end
  end
end
