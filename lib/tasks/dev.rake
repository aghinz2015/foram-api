require 'fabrication'
require 'faker'

namespace :dev do
  namespace :db do
    desc "Populate database with random forams (removes existing ones)"
    task populate: :environment do
      Foram.destroy_all

      Fabricate.times(1000, :foram) do
        death_hour  Faker::Number.between(30, 50)
        age         Faker::Number.between(5, 15)

        is_diploid       { rand > 0.5 }
        genotype         { |foram| Fabricate.build(:genotype, is_diploid: foram[:is_diploid]) }
      end
    end

    desc "Create example descendants hierarchy"
    task set_hierarchy: :environment do
      forams = Foram.all[0...25]

      forams.each do |foram|
        foram.first_parent_id = nil
        foram.second_parent_id = nil
      end

      def set_hierarchy(collection, descendants_array)
        descendants_array.each { |pair| set_parent(collection, pair.first, pair.last) }
        collection.each(&:save)
      end

      def set_parent(forams, foram_number, parent_number)
        child = forams[foram_number]
        parent_id = forams[parent_number].foram_id

        if rand(2) == 0
          child.first_parent_id = parent_id
        else
          child.second_parent_id = parent_id
        end
      end

      descendants = [
        [1, 0], [2, 0], [3, 0], [4, 0],
        [5, 1], [6, 1], [7, 2], [8, 4], [9, 4], [10, 4],
        [11, 5], [12, 6], [13, 6], [14, 6], [15, 7], [16, 7], [17, 8], [18, 8], [19, 10],
        [20, 11], [21, 11], [22, 13], [23, 13], [24, 18]
      ]

      set_hierarchy(forams, descendants)

      puts "Root: " + forams.first.id
    end
  end
end
