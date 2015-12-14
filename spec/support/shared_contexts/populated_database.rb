shared_context 'populated database' do
  let(:database_population) { 50 }

  before do
    Fabrication::Sequencer.reset
    database_population.times do
      Fabricate(:foram) do
        x { sequence(:x) }
        age { sequence(:age) { |i| 20 + i / 5 } }
        deathHour { sequence(:deathHour) { |i| 30 + i / 2 } }
        isDiploid { sequence(:isDiploid) { |i| i % 2 == 0 } }
        genotype { sequence(:genotype) { |i| Fabricate.build(:genotype, isDiploid: (i % 2 == 0), range: i..i) } }
      end
    end
  end
end
