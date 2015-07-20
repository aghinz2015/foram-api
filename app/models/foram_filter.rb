class ForamFilter
  include ActiveModel::Model
  include RangedFilter

  ranged_attribute %w(genotype.deviation_angle genotype.growth_factor
                      genotype.rotation_angle genotype.translation_factor
                      genotype.wall_thickness_factor)

  def forams
    ranged_attributes_scope(Foram.all)
  end
end
