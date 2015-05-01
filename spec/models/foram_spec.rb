require "rails_helper"

describe Foram do
  include Mongoid::Matchers

  FIELDS = [:kx, :ky, :kz, :tf, :phi, :beta]

  it { should have_fields(*FIELDS) }

  describe "validations" do
    FIELDS.each do |field|
      it { should validate_presence_of field }
    end
  end
end
