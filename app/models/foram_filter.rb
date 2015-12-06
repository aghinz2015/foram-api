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

  def self.params(user: nil, camelize: false)
    names = []
    foram = for_user(user).first
    attribute_names = foram.attributes.keys + foram.genotype.attributes.keys.map{ |k| "genotype.#{k}"} rescue []
    attribute_names.each do |name|
      case foram.read_attibute(name)
      when Array, Numeric
        names << "#{name}_max"
        names << "#{name}_min"
      when TrueClass, FalseClass
        names << name
      end
    end
    camelize ? names : names.map(&:underscore)
  end

  def ordered_scope(forams, ordering_params)
    return forams unless ordering_params && ordering_params[:order_by]
    order_by = ordering_params[:order_by]

    if forams.all_attribute_names(camelize: true).include?(order_by)
      direction = ordering_params[:direction]
      direction = "asc" unless ["asc", "desc"].include?(direction)
      forams.order_by(forams.find_mapping(order_by) => direction.to_sym)
    else
      forams
    end
  end
end
