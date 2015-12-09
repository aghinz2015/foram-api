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
        translation_factor: [0.1, 0.2, 0.3],
        growth_factor:      [0.2, 0.3, 0.4],
        rotation_angle:     [0.3, 0.4, 0.5],
        deviation_angle:    [0.4, 0.5, 0.6]
      ),

      Fabricate(:genotype,
        foram:              forams[1],
        translation_factor: [0.5, 0.6, 0.7],
        growth_factor:      [0.6, 0.7, 0.8],
        rotation_angle:     [0.7, 0.8, 0.9],
        deviation_angle:    [0.8, 0.9, 1.0]
      )
    ]
  end
end
