class Genotype
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  embedded_in :foram

  # field :haploidJuvenileVolumeFactor,  type: Gene
  # field :haploidFirstChamberRadius,    type: Gene
  # field :minAdultAge,                  type: Gene
  # field :chamberGrowthCostFactor,      type: Gene
  # field :energyDemandPerChamber,       type: Gene
  # field :minAdultVolume,               type: Gene
  # field :wallThicknessFactor,          type: Gene
  # field :minEnergy,                    type: Gene
  # field :metabolicEffectiveness,       type: Gene
  # field :diploidJuvenileVolumeFactor,  type: Gene
  # field :diploidFirstChamberRadius,    type: Gene
  # field :hibernationEnergyConsumption, type: Gene
  # field :translationFactor,            type: Gene
  # field :growthFactor,                 type: Gene
  # field :hibernationEnergyLevel,       type: Gene
  # field :rotationAngle,                type: Gene
  # field :deviationAngle,               type: Gene
  # field :minMetabolicEffectiveness,    type: Gene
  # field :maxEnergyPerChamber,          type: Gene

  # alias_underscored_attributes

  def method_missing(method, *args, &block)
    super method.to_s.camelize(:lower).to_sym, *args, &block
  end
end
