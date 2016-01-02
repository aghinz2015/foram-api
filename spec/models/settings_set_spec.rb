require 'rails_helper'

describe SettingsSet do
  include Mongoid::Matchers

  it { is_expected.to have_fields(:number_precision, :tree_level, :per_page, :mappings) }
  it { is_expected.to be_embedded_in(:user) }
  it { is_expected.to validate_presence_of(:number_precision) }
  it { is_expected.to validate_presence_of(:tree_level) }
  it { is_expected.to validate_presence_of(:per_page) }
end
