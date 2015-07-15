require 'rails_helper'

describe Genotype do
  include Mongoid::Matchers

  it { should have_fields(:haploidJuvenileVolumeFactor, :haploidFirstChamberRadius, :minAdultAge, :minEnergy) }
  it { should have_fields(:chamberGrowthCostFactor, :energyDemandPerChamber, :minAdultVolume, :wallThicknessFactor) }
  it { should have_fields(:metabolicEffectiveness, :diploidJuvenileVolumeFactor, :diploidFirstChamberRadius) }
  it { should have_fields(:translationFactor, :growthFactor, :hibernationEnergyLevel, :hibernationEnergyConsumption) }
  it { should have_fields(:rotationAngle, :deviationAngle, :minMetabolicEffectiveness, :maxEnergyPerChamber) }
end
