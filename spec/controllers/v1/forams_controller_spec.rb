require 'rails_helper'

describe V1::ForamsController do
  describe '#show' do
    let!(:foram) { Fabricate(:foram) }

    before { get :show, id: foram.id }

    it 'renders json representation of existing foram record' do
      expect(json_response[:foram][:genotype][:growthFactor]).to eq foram.genotype.growthFactor.as_json.symbolize_keys
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
