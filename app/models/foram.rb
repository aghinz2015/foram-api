class Foram
  include Mongoid::Document
  embeds_one :genotype

  field :className,       type: String
  field :deathStepNo,     type: Integer
  field :age,             type: Integer
  field :x,               type: Integer
  field :y,               type: Integer
  field :z,               type: Integer
  field :simulationStart, type: DateTime
end
