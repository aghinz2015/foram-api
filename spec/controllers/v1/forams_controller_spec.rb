require 'rails_helper'

describe V1::ForamsController do
  describe '#show' do
    let!(:foram) { Fabricate(:foram) }

    before { get :show, id: foram.id }

    it 'renders existing foram record' do
      rendered_foram = json_response[:foram]

      expect(rendered_foram[:genotype][:growthFactor]).to eq foram.genotype.growthFactor
    end

    it { should respond_with 200 }
  end

  describe '#index' do
    let!(:forams) { 3.times.map { Fabricate(:foram) } }

    before { get :index }

    it 'renders all foram records' do
      expect(json_response[:forams].size).to eq 3
    end

    it { should respond_with 200 }
  end

  describe '#destroy' do
    let!(:foram) { Fabricate(:foram) }

    before { delete :destroy, id: foram.id }

    it { should respond_with 204 }
  end
end
