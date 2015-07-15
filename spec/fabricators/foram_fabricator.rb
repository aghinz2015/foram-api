Fabricator(:genotype) do
  transient is_diploid: false

  haploidJuvenileVolumeFactor  { |transients| Fabricate(:gene, range: (0.0..10.0), is_diploid: transients[:is_diploid]) }
  haploidFirstChamberRadius    { |transients| Fabricate(:gene, range: (0.0..10.0), is_diploid: transients[:is_diploid]) }
  chamberGrowthCostFactor      { |transients| Fabricate(:gene, range: (0.0..1.0),  is_diploid: transients[:is_diploid]) }
  energyDemandPerChamber       { |transients| Fabricate(:gene, range: (0.0..1.0),  is_diploid: transients[:is_diploid]) }
  minAdultVolume               { |transients| Fabricate(:gene, range: (10..100),   is_diploid: transients[:is_diploid]) }
  minAdultAge                  { |transients| Fabricate(:gene, range: (100..900),  is_diploid: transients[:is_diploid]) }
  wallThicknessFactor          { |transients| Fabricate(:gene, range: (0.0..0.04), is_diploid: transients[:is_diploid]) }
  minEnergy                    { |transients| Fabricate(:gene, range: (5..50),     is_diploid: transients[:is_diploid]) }
  metabolicEffectiveness       { |transients| Fabricate(:gene, range: (0.0..1.0),  is_diploid: transients[:is_diploid]) }
  diploidJuvenileVolumeFactor  { |transients| Fabricate(:gene, range: (0.0..10.0), is_diploid: transients[:is_diploid]) }
  diploidFirstChamberRadius    { |transients| Fabricate(:gene, range: (0.0..10.0), is_diploid: transients[:is_diploid]) }
  hibernationEnergyConsumption { |transients| Fabricate(:gene, range: (0.1..1.0),  is_diploid: transients[:is_diploid]) }
  translationFactor            { |transients| Fabricate(:gene, range: (-1.0..1.0), is_diploid: transients[:is_diploid]) }
  growthFactor                 { |transients| Fabricate(:gene, range: (1.0..2.0),  is_diploid: transients[:is_diploid]) }
  hibernationEnergyLevel       { |transients| Fabricate(:gene, range: (1.0..10.0), is_diploid: transients[:is_diploid]) }
  rotationAngle                { |transients| Fabricate(:gene, range: (-3.1..3.1), is_diploid: transients[:is_diploid]) }
  deviationAngle               { |transients| Fabricate(:gene, range: (-3.1..3.1), is_diploid: transients[:is_diploid]) }
  minMetabolicEffectiveness    { |transients| Fabricate(:gene, range: (1.0..10.0), is_diploid: transients[:is_diploid]) }
  maxEnergyPerChamber          { |transients| Fabricate(:gene, range: (1.0..10.0), is_diploid: transients[:is_diploid]) }
  foram
end

Fabricator(:foram) do
  className         { 'pl.edu.agh.evolutus.statistics.model.ForamFossil' }
  foramId           { Faker::Lorem.characters(32) }
  deathStepNo       { Faker::Number.number(5) }
  age               { Faker::Number.number(4) }
  isDiploid         { rand > 0.5 }
  x                 { Faker::Number.number(1) }
  y                 { Faker::Number.number(1) }
  z                 { Faker::Number.number(1) }
  simulationStart   { Time.now - rand(50) }

  after_create do |foram|
    Fabricate(:genotype, foram: foram, is_diploid: foram.isDiploid)
  end
end
