require 'rails_helper'

describe Foram do
  include Mongoid::Matchers

  it { should have_fields(:className, :foramId, :deathStepNo, :age, :isDiploid, :foramType, :x, :y, :z, :simulationStart) }
  it { should embed_one :genotype }
end
