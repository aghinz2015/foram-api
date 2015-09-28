class ForamFilter
  include Mongoid::Document
  include ::Filters::RangedFilter
  include ::Filters::BooleanFilter

  belongs_to :user

  ranged_attribute :mongoid,
    haploid_juvenile_volume_factor: 'genotype.haploidJuvenileVolumeFactor.0',
    haploid_first_chamber_radius: 'genotype.haploidFirstChamberRadius.0',
    min_adult_age: 'genotype.minAdultAge.0',
    chamber_growth_cost_factor: 'genotype.chamberGrowthCostFactor.0',
    energy_demand_per_chamber: 'genotype.energyDemandPerChamber.0',
    min_adult_volume: 'genotype.minAdultVolume.0',
    wall_thickness_factor: 'genotype.wallThicknessFactor.0',
    min_energy: 'genotype.minEnergy.0',
    metabolic_effectiveness: 'genotype.metabolicEffectiveness.0',
    diploid_juvenile_volume_factor: 'genotype.diploidJuvenileVolumeFactor.0',
    diploid_first_chamber_radius: 'genotype.diploidFirstChamberRadius.0',
    hibernation_energy_consumption: 'genotype.hibernationEnergyConsumption.0',
    translation_factor: 'genotype.translationFactor.0',
    growth_factor: 'genotype.growthFactor.0',
    hibernation_energy_level: 'genotype.hibernationEnergyLevel.0',
    rotation_angle: 'genotype.rotationAngle.0',
    deviation_angle: 'genotype.deviationAngle.0',
    min_metabolic_effectiveness: 'genotype.minMetabolicEffectiveness.0',
    max_energy_per_chamber: 'genotype.maxEnergyPerChamber.0',
    x: 'x',
    y: 'y',
    z: 'z',
    death_step_no: 'deathStepNo',
    age: 'age',
    generation: 'generation'

  boolean_attribute :mongoid,
    is_diploid: 'isDiploid'

  validates :user, presence: true

  def forams
    forams = boolean_attributes_scope(Foram.all)
    ranged_attributes_scope(forams)
  end

  def self.params
    @params ||= (boolean_attributes + ranged_attributes).map { |a| a[0].to_sym }
  end
end
