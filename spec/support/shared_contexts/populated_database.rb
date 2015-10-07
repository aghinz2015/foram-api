shared_context 'populated database' do
  let(:database_population) { 50 }

  before do
    Fabrication::Sequencer.reset
    database_population.times do
      Fabricate(:foram) do
        x { sequence(:x) }
        age { sequence(:age) { |i| 20 + i / 5 } }
        death_step_no { sequence(:death_step_no) { |i| 30 + i / 2 } }
        is_diploid { sequence(:is_diploid) { |i| i % 2 == 0 } }
        genotype { sequence(:genotype) { |i| Fabricate.build(:genotype, is_diploid: (i % 2 == 0), range: i..i) } }
      end
    end
  end
end