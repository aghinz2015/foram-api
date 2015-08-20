require 'rails_helper'

describe GenerationMetricCalculator do
  describe "#generation_metrics" do
    subject { GenerationMetricCalculator.new(forams) }
    
    let(:forams) do 
      [
        Fabricate(:foram, x: 1, y: 2, z: 3, age: 20, death_step_no: 30),
        Fabricate(:foram, x: 2, y: 3, z: 4, age: 20, death_step_no: 30),
        Fabricate(:foram, x: 3, y: 4, z: 5, age: 20, death_step_no: 30),
        Fabricate(:foram, x: 4, y: 5, z: 6, age: 20, death_step_no: 35)
      ]
     end

    it "returns hash with generation numbers as keys" do
      expect(subject.generation_metrics.keys).to include(10, 15)
    end

    it "returns hash with global_averages key" do
      expect(subject.generation_metrics.keys).to include(:global_averages)
    end

    it "calculates metrics of all plottable foram metrics" do
      expect(subject.generation_metrics[:global_averages].keys).to match_array [:x, :y, :z, :age]
    end

    it "returns hash which has information about generation size" do
      expect(subject.generation_metrics[10][:size]).to eq 3
    end

    it "returns hash which has information about minimal attribute value per generation" do
      expect(subject.generation_metrics[10][:attributes][:y][:min]).to eq 2
    end

    it "returns hash which has information about maximal attribute value per generation" do
      expect(subject.generation_metrics[10][:attributes][:y][:max]).to eq 4
    end

    it "returns hash which has information about average attribute value per generation" do
      expect(subject.generation_metrics[10][:attributes][:y][:average]).to eq 3
    end

    it "returns hash which has information about standard deviation of attribute value per generation" do
      expect(subject.generation_metrics[10][:attributes][:y][:standard_deviation]).to eq 0.82
    end
  end
end