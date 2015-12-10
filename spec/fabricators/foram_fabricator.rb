Fabricator(:foram) do
  class_name       'pl.edu.agh.evolutus.statistics.model.ForamFossil'
  foram_id         { Faker::Lorem.characters(32) }
  death_hour       { Faker::Number.number(5).to_i }
  age              { Faker::Number.number(4).to_i }
  is_diploid       { rand > 0.5 }
  chambers_count   { Faker::Number.number(1).to_i }
  x                { Faker::Number.number(1).to_i }
  y                { Faker::Number.number(1).to_i }
  z                { Faker::Number.number(1).to_i }
  simulation_start { Time.now - rand(50) }

  genotype         { |foram| Fabricate.build(:genotype, is_diploid: foram[:isDiploid]) }
end
