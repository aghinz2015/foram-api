Fabricator(:genotype) do
  haploidJuvenileVolumeFactor  { rand * 10 }
  haploidFirstChamberRadius    { rand * 10 }
  minAdultAge                  { rand(20) + 20 }
  minAdultVolume               { rand * 10 }
  wallThicknessFactor          { rand / 25 }     # 0% - 4%
  maxEnergy                    { rand }
  diploidFirstChamberRadius    { (rand < 0.5) ? rand * 10 : 0 }
  diploidJuvenileVolumeFactor  { |params| params[:diploidFirstChamberRadius] != 0 ? rand * 10 : 0 }
  minEnergy                    { rand * 10 }
  metabolicEffectiveness       { rand * 10 }
  translationFactor            { rand * 2 - 1 }  # -1 - 1
  growthFactor                 { rand + 1 }      #  1 - 2
  rotationAngle                { Math::PI * (rand * 2 - 1) } # -pi - pi
  deviationAngle               { Math::PI * (rand * 2 - 1) } # -pi - pi
  minMetabolicEffectiveness    { rand * 10 }
end

Fabricator(:foram) do
  className         "pl.edu.agh.evolutus.statistics.model.ForamFossil"
  deathStepNo       { rand(300) + 100 }
  age               { rand(10) + 5 }
  x                 { rand(10) }
  y                 { rand(10) }
  z                 { rand(10) }
  simulationStart   { Time.now - rand(50) }

  after_create do |foram|
    Fabricate(:genotype, foram: foram)
  end
end
