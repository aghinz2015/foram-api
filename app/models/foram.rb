class Foram
  include Mongoid::Document
  require 'csv'

  embeds_one :genotype

  field :className,       type: String
  field :foramId,         type: String
  field :deathStepNo,     type: Integer
  field :age,             type: Integer
  field :isDiploid,       type: Boolean
  field :foramType,       type: String
  field :x,               type: Integer
  field :y,               type: Integer
  field :z,               type: Integer
  field :simulationStart, type: DateTime
  field :generation,      type: Integer

  alias_underscored_attributes

  before_create :calculate_generation

  def self.for_user(user)
    session = user.try { |user| user.mongo_sessions.active.last }
    if session
      session.connect
      with(session: session.config_name).all
    else
      all
    end
  end

  def self.to_csv
    attributes = Foram.attribute_names + Genotype.attribute_names
    attributes.delete('_id')
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |foram|
        csv << foram.attributes.merge!(foram.genotype.attributes)
      end
    end
  end

  private

  def calculate_generation
    self.generation = deathStepNo - age
  end
end
