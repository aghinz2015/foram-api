Fabricator(:foram) do
  className         'pl.edu.agh.evolutus.statistics.model.ForamFossil'
  foramId           { Faker::Lorem.characters(32) }
  deathStepNo       { Faker::Number.number(5) }
  age               { Faker::Number.number(4) }
  isDiploid         { rand > 0.5 }
  x                 { Faker::Number.number(1) }
  y                 { Faker::Number.number(1) }
  z                 { Faker::Number.number(1) }
  simulationStart   { Time.now - rand(50) }

  genotype          { |foram| Fabricate.build(:genotype, is_diploid: foram[:isDiploid]) }
end
