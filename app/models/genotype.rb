class Genotype
  include Mongoid::Document
  embedded_in :foram

  field :haploidJuvenileVolumeFactor, type: Float
  field :haploidFirstChamberRadius,   type: Float
  field :minAdultAge,                 type: Float
  field :minAdultVolume,              type: Float
  field :wallThicknessFactor,         type: Float
  field :maxEnergy,                   type: Float
  field :diploidFirstChamberRadius,   type: Float
  field :diploidJuvenileVolumeFactor, type: Float
  field :minEnergy,                   type: Float
  field :metabolicEffectiveness,      type: Float
  field :translationFactor,           type: Float
  field :growthFactor,                type: Float
  field :rotationAngle,               type: Float
  field :deviationAngle,              type: Float
  field :minMetabolicEffectiveness,   type: Float
end
