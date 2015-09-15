require 'fabrication'
require 'faker'

namespace :dev do
  namespace :db do
    desc "Populate database with random forams (removes existing ones)"
    task populate: :environment do
      Foram.destroy_all

      Fabricate.times(1000, :foram) do
        death_step_no Faker::Number.between(30, 50)
        age         Faker::Number.between(5, 15)

        is_diploid       { rand > 0.5 }
        genotype         { |foram| Fabricate.build(:genotype, is_diploid: foram[:is_diploid]) }
      end
    end
  end
end