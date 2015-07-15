Fabricator(:gene) do
  transient range: (0.0..1.0), is_diploid: false

  after_build do |gene, transients|
    range = transients[:range]
    random_sample = -> { range.begin.respond_to?(:succ) ? range.to_a.sample : rand(range) }

    gene.effective = random_sample.call
    if transients[:is_diploid]
      gene.first_set  = random_sample.call
      gene.second_set = random_sample.call
    end
  end
end
