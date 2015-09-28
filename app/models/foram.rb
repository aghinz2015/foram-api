class Foram
  include Mongoid::Document

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

  private

  def calculate_generation
    self.generation = deathStepNo - age
  end
end
