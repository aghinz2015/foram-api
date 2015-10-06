class ForamSerializer < ActiveModel::Serializer
  attributes :id, :death_step_no, :age, :is_diploid, :x, :y, :z, :simulation_start

  has_one :genotype
end
