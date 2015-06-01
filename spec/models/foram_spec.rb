require 'rails_helper'

describe Foram do
  include Mongoid::Matchers

  it { should have_fields(:className, :deathStepNo, :age, :x, :y, :z, :simulationStart) }
  it { should embed_one :genotype }
end
