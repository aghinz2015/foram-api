require 'fabrication'
require 'faker'

namespace :dev do
  namespace :db do
    desc "Populate database with random forams (removes existing ones)"
    task populate: :environment do
      Foram.destroy_all

      Fabricate.times(10, :foram) do
        deathStepNo Faker::Number.between(30, 80)
        age         Faker::Number.between(5, 30)
      end
    end
  end
end