# class ForamFilter
#   include ActiveModel::Model
#   ATTRIBUTES = %w(deviation_angle_min         deviation_angle_max
#                   growth_factor_min           growth_factor_max
#                   rotation_angle_min          rotation_angle_max
#                   translation_factor_min      translation_factor_max
#                   wall_thickness_factor_min   wall_thickness_factor_max).freeze
#   attr_accessor *ATTRIBUTES

#   def forams
#     @forams ||= find_forams
#   end

#   private

#   def find_forams
#     conditions = {}
#     ATTRIBUTES.each do |attribute|
#       conditions.deep_merge!(number_condition(attribute)) if send(attribute).present?
#     end
#     Foram.where(conditions)
#   end

#   def number_condition(key)
#     operator = key =~ /_min\z/ ? '$gte' : '$lte'
#     { "genotype.#{key[0..-5].camelize(:lower)}": { operator => send(key) } }
#   end
# end

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
