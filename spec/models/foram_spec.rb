require 'rails_helper'

describe Foram do
  include Mongoid::Matchers

  it { should embed_one :genotype }
end
