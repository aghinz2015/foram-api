class ForamFilter
  include Mongoid::Document
  include ::Filters::RangedFilter
  include ::Filters::BooleanFilter

  field :name, type: String
  belongs_to :user

  private

  def self.foram_ranged_parameters_mapping
    @mapping ||= {}.tap do |result|
      extract_ranged_parameters(Foram).each { |param| result[param.to_sym] = param.camelize(:lower) }
      extract_ranged_parameters(Genotype).each { |param| result[param.to_sym] = "genotype.#{param.camelize(:lower)}.0" }
    end
  end

  def self.extract_ranged_parameters(klass)
    klass.fields.select { |name, field| [Integer, Array].include?(field.type) }.keys.map!(&:underscore)
  end

  public

  ranged_attribute :mongoid, foram_ranged_parameters_mapping

  boolean_attribute :mongoid,
    is_diploid: 'isDiploid'

  validates :user, presence: true

  def forams(user: nil, order: nil)
    forams = boolean_attributes_scope(Foram.for_user(user))
    ordered_scope(ranged_attributes_scope(forams), order)
  end

  def self.params
    @params ||= (boolean_attributes + ranged_attributes).map { |a| a[0].to_sym } << 'name'
  end

  def ordered_scope(forams, ordering_params)
    return forams unless ordering_params && ordering_params[:order_by]
    order_by = ordering_params[:order_by].underscore.to_sym

    if ForamFilter.foram_ranged_parameters_mapping.has_key?(order_by)
      direction = ordering_params[:direction]
      direction = "asc" unless ["asc", "desc"].include?(direction)
      forams.order_by(ForamFilter.foram_ranged_parameters_mapping[order_by] => direction.to_sym)
    else
      forams
    end
  end
end
