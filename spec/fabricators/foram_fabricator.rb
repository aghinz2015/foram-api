require_relative "../support/fabricator_helper"

Fabricator(:genotype) do
  transient is_diploid: false

  after_build do |genotype, transients|
    fields = FabricatorHelper.attributes_for('foram')

    fields.keys.each do |field|
      range = fields[field][:range]
      genotype.send("#{field}=", Fabricate(:gene, range: range, is_diploid: transients[:is_diploid]))
    end
  end

  foram
end

Fabricator(:foram) do
  className         { 'pl.edu.agh.evolutus.statistics.model.ForamFossil' }
  foramId           { Faker::Lorem.characters(32) }
  deathStepNo       { Faker::Number.number(5) }
  age               { Faker::Number.number(4) }
  isDiploid         { rand > 0.5 }
  x                 { Faker::Number.number(1) }
  y                 { Faker::Number.number(1) }
  z                 { Faker::Number.number(1) }
  simulationStart   { Time.now - rand(50) }

  after_build do |foram|
    foram.genotype = Fabricate.build(:genotype, foram: foram, is_diploid: foram.isDiploid)
  end
end
