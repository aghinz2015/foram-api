require "rails_helper"

describe Genotype do
  include Mongoid::Matchers

  it { should have_fields(:haploidFirstChamberRadius, :haploidJuvenileVolumeFactor) }
  it { should have_fields(:diploidFirstChamberRadius, :diploidJuvenileVolumeFactor) }
  it { should have_fields(:minAdultAge, :minAdultVolume, :minEnergy, :maxEnergy) }
  it { should have_fields(:metabolicEffectiveness, :minMetabolicEffectiveness) }

  it { should have_fields(:wallThicknessFactor, :translationFactor, :growthFactor) }
  it { should have_fields(:rotationAngle, :deviationAngle) }
end
