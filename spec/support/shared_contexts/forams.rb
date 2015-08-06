shared_context 'forams' do
  let!(:forams) do
    [
      Fabricate(:foram, id: 'f1'),
      Fabricate(:foram, id: 'f2')
    ]
  end

  let!(:genotypes) do
    [
      Fabricate(:genotype,
        foram:              forams[0],
        translation_factor: Fabricate(:gene, effective: 0.1, first_set: 0.2, second_set: 0.3),
        growth_factor:      Fabricate(:gene, effective: 0.2, first_set: 0.3, second_set: 0.4),
        rotation_angle:     Fabricate(:gene, effective: 0.3, first_set: 0.4, second_set: 0.5),
        deviation_angle:    Fabricate(:gene, effective: 0.4, first_set: 0.5, second_set: 0.6)
      ),

      Fabricate(:genotype,
        foram:              forams[1],
        translation_factor: Fabricate(:gene, effective: 0.5, first_set: 0.6, second_set: 0.7),
        growth_factor:      Fabricate(:gene, effective: 0.6, first_set: 0.7, second_set: 0.8),
        rotation_angle:     Fabricate(:gene, effective: 0.7, first_set: 0.8, second_set: 0.9),
        deviation_angle:    Fabricate(:gene, effective: 0.8, first_set: 0.9, second_set: 1.0)
      )
    ]
  end
end
