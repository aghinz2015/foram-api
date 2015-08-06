Fabricator :gene do
  transient range: (0.0..1.0), is_diploid: false

  effective  { |attrs| rand attrs[:range] }
  first_set  { |attrs| rand attrs[:range] if attrs[:is_diploid] }
  second_set { |attrs| rand attrs[:range] if attrs[:is_diploid] }
end
