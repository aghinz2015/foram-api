require 'rails_helper'

describe SettingsSet do
  include Mongoid::Matchers

  it { is_expected.to have_fields(:number_precision, :mappings) }
  it { is_expected.to be_embedded_in(:user) }
  it { is_expected.to validate_presence_of(:number_precision) }
end