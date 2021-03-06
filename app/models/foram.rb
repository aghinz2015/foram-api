class Foram
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  require 'csv'

  embeds_one :genotype

  scope :simulation_start, ->(id) { where(simulationStart: id.try(:to_i)) if id }

  def method_missing(method, *args, &block)
    if respond_to?(method_name = method.to_s.underscore.to_sym)
      super method_name, *args, &block
    else
      super method.to_s.camelize(:lower).to_sym, *args, &block
    end
  end

  def self.for_user(user)
    session = user.try { |user| user.mongo_sessions.active.last }
    if session
      session.connect
      with(session: session.config_name, collection: session.foram_collection)
    else
      self
    end
  end

  def self.all_attribute_names(user: nil, camelize: false)
    foram = for_user(user).first
    names = foram.attributes.keys + foram.genotype.attributes.keys rescue []
    names -= %w(_id genotype)
    camelize ? names : names.map(&:underscore)
  end

  def self.filterable_attribute_names(user: nil, camelize: false, only_numeric: false, only_genotype: false)
    types = [Array, Numeric]
    types.concat [TrueClass, FalseClass] unless only_numeric
    foram = for_user(user).first
    attributes = only_genotype ? foram.genotype.attributes : foram.attributes.merge!(foram.genotype.attributes)

    names = attributes.select { |key, value| types.any? { |type| value.is_a? type } }.keys
    camelize ? names : names.map(&:underscore)
  end

  def self.find_mapping(attribute, user: nil)
    foram = for_user(user).first
    if foram.attributes.keys.include? attribute
      attribute
    elsif foram.genotype.attributes.keys.include? attribute
      "genotype.#{attribute}.0"
    else
      raise "Attribute #{attribute} was not found"
    end
  end

  def self.attribute_stats(attribute)
    attribute = attribute.to_s.camelize(:lower)
    forams = all
    if forams.first.genotype.attributes.keys.include? attribute
      attribute = "genotype.#{attribute}"
      { max: forams.max(attribute).first, min: forams.min(attribute).first }
    else
      { max: forams.max(attribute), min: forams.min(attribute) }
    end
  end

  def self.to_csv(options = {})
    attributes = all.all_attribute_names(camelize: true)
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |foram|
        csv << foram.attributes.merge!(foram.genotype.attributes)
      end
    end
  end

  def self.to_gen(options = {})
    all.map do |foram|
      genotype = foram.genotype
      gf = genotype.growth_factor.effective
      ["org\ngenotype:/*F*/#{foram.chambers_count}",
        gf, gf, gf,
        genotype.translation_factor.effective,
        genotype.deviation_angle.effective,
        genotype.rotation_angle.effective
      ].join(",")
    end.join("\n\n")
  end
end
