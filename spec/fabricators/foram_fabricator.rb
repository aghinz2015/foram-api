Fabricator(:foram) do
  class_name       'pl.edu.agh.evolutus.statistics.model.ForamFossil'
  foram_id         { Faker::Lorem.characters(32) }
  death_hour       { Faker::Number.number(5) }
  age              { Faker::Number.number(4) }
  is_diploid       { rand > 0.5 }
  chambers_count   { Faker::Number.number(1) }
  x                { Faker::Number.number(1) }
  y                { Faker::Number.number(1) }
  z                { Faker::Number.number(1) }
  simulation_start { Time.now - rand(50) }

  genotype         { |foram| Fabricate.build(:genotype, is_diploid: foram[:isDiploid]) }
end

