class GenotypeSerializer < ActiveModel::Serializer
  attributes :haploid_juvenile_volume_factor,
             :haploid_first_chamber_radius,
             :min_adult_age,
             :chamber_growth_cost_factor,
             :energy_demand_per_chamber,
             :min_adult_volume,
             :wall_thickness_factor,
             :min_energy,
             :metabolic_effectiveness,
             :diploid_juvenile_volume_factor,
             :diploid_first_chamber_radius,
             :hibernation_energy_consumption,
             :translation_factor,
             :growth_factor,
             :hibernation_energy_level,
             :rotation_angle,
             :deviation_angle,
             :min_metabolic_effectiveness,
             :max_energy_per_chamber
end
