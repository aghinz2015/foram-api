Fabricator(:settings_set) do
  number_precision  { Faker::Number.number(3) }
  mappings          {}
end