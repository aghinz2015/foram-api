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

  alias_underscored_attributes

  def generation
    deathStepNo - age
  end
end
