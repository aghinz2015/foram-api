class ForamFilter
  include ActiveModel::Model
  include ::Filters::RangedFilter

  ranged_attribute deviation_angle:         'genotype.deviationAngle.0',
                   growth_factor:           'genotype.growthFactor.0',
                   rotation_angle:          'genotype.rotationAngle.0',
                   translation_factor:      'genotype.translationFactor.0',
                   wall_thickness_factor:   'genotype.wallThicknessFactor.0'

  def forams
    ranged_attributes_scope(Foram.all)
  end
end
