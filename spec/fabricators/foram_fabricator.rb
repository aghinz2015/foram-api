Fabricator(:foram) do
  className        'pl.edu.agh.evolutus.statistics.model.ForamFossil'
  foramId          { Faker::Lorem.characters(32) }
  deathHour        { Faker::Number.number(5).to_i }
  age              { Faker::Number.number(4).to_i }
  isDiploid        { rand > 0.5 }
  chambersCount    { Faker::Number.number(1).to_i }
  x                { Faker::Number.number(1).to_i }
  y                { Faker::Number.number(1).to_i }
  z                { Faker::Number.number(1).to_i }
  simulationStart  { rand(5) }
  firstParentId    { nil }
  secondParentId   { nil }

  genotype         { |foram| Fabricate.build(:genotype, isDiploid: foram[:isDiploid]) }
end
