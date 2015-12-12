class ForamFilter
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include ::Filters::RangedFilter
  include ::Filters::BooleanFilter

  field :name, type: String
  belongs_to :user

  validates :user, presence: true

  def forams(user: nil, order: nil)
    forams = boolean_attributes_scope(Foram.for_user(user))
    ordered_scope(ranged_attributes_scope(forams), order)
  end

  def self.attributes_map(scope)
    @names_map = {}
    @foram = scope.first
    return @names_map if @foram.nil? || @foram[:genotype].nil?

    @foram.attributes.keys.map(&:to_s).each { |name| map_attribute name, name }
    @foram.genotype.attributes.keys.map(&:to_s).each { |name| map_attribute name, "genotype.#{name}" }
    @names_map.transform_keys { |key| key.underscore }
  end

  def ordered_scope(forams, ordering_params)
    return forams unless ordering_params && ordering_params[:order_by]
    order_by = ordering_params[:order_by].camelize(:lower)

    if forams.all_attribute_names(camelize: true).include?(order_by)
      direction = ordering_params[:direction]
      direction = "asc" unless ["asc", "desc"].include?(direction)
      forams.order_by(forams.find_mapping(order_by) => direction.to_sym)
    else
      forams
    end
  end

  private

  def self.map_attribute(name, path)
    case @foram.read_attribute path
    when Array
      @names_map["#{name}_max"] = "#{path}.0"
      @names_map["#{name}_min"] = "#{path}.0"
    when Numeric
      @names_map["#{name}_max"] = path
      @names_map["#{name}_min"] = path
    when TrueClass, FalseClass
      @names_map[name.underscore] = path
    end
  end
end
