class Foram
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  require 'csv'

  embeds_one :genotype

  def method_missing(method, *args, &block)
    super method.to_s.camelize(:lower).to_sym, *args, &block
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

  def self.all_attribute_names(user=nil)
    if user.present?
      foram = for_user(user).first
      names = foram.attributes.keys + foram.genotype.attributes.keys rescue []
    else
      names = attribute_names + Genotype.attribute_names
    end
    names.map!(&:underscore) - %w(_id genotype)
  end

  def self.to_csv(options)
    attributes = all_attribute_names options[:user]
    attributes.delete('_id')
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |foram|
        csv << foram.attributes.merge!(foram.genotype.attributes)
      end
    end
  end

  def self.to_gen(options)
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

  def generation
    deathStepNo - age
  end
end
