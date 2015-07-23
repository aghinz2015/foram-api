class ForamFilter
  include ActiveModel::Model
  include RangedFilter

  ranged_attribute deviation_angle:         'genotype.deviationAngle',
                   growth_factor:           'genotype.growthFactor',
                   rotation_angle:          'genotype.rotationAngle',
                   translation_factor:      'genotype.translationFactor',
                   wall_thickness_factor:   'genotype.wallThicknessFactor'

  def forams
    ranged_attributes_scope(Foram.all)
  end
end
