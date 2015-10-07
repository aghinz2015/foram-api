require 'rails_helper'

describe ForamFilter do
  let(:user) { nil }
  let(:order) { nil }

  include_context "populated database"
  let(:database_population) { 6 }

  describe "ordering" do
    describe "by foram attribute" do
      let(:order) { { order_by: "x" } }

      it "returns forams sorted by foram attribute" do
        expect(subject.forams(order: order).map(&:x)).to eq [0, 1, 2, 3, 4, 5]
      end
    end

    describe "by genotype attribute" do
      let(:order) { { order_by: "rotation_angle" } }

      it "returns forams sorted by genotype attribute" do
        expect(subject.forams(order: order).map { |foram| foram.genotype.rotation_angle.effective }).to eq [0, 1, 2, 3, 4, 5]
      end
    end

    context "with specified direction" do
      let(:order) { { order_by: "x", direction: "desc" } }

      it "returns forams sorted with specified ordering" do
        expect(subject.forams(order: order).map(&:x)).to eq [5, 4, 3, 2, 1, 0]
      end
    end
  end
end