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
        translationFactor:  [0.1, 0.2, 0.3],
        growthFactor:       [0.2, 0.3, 0.4],
        rotationAngle:      [0.3, 0.4, 0.5],
        deviationAngle:     [0.4, 0.5, 0.6]
      ),

      Fabricate(:genotype,
        foram:              forams[1],
        translationFactor:  [0.5, 0.6, 0.7],
        growthFactor:       [0.6, 0.7, 0.8],
        rotationAngle:      [0.7, 0.8, 0.9],
        deviationAngle:     [0.8, 0.9, 1.0]
      )
    ]
  end
end
