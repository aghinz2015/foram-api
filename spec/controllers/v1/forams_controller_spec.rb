require 'rails_helper'

describe V1::ForamsController do
  describe 'GET #show' do
    let!(:foram) { Fabricate(:foram) }

    before { get :show, id: foram.id }

    it 'renders json representation of existing foram record' do
      expect(json_response[:foram][:genotype][:growthFactor]).to eq foram.genotype.growthFactor
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    let!(:forams) { 3.times.map { Fabricate(:foram) } }

    before { get :index }

    it 'returns json representation of all foram records' do
      expect(json_response[:forams].size).to eq 3
    end

    it { should respond_with 200 }
  end

  describe 'DELETE #destroy' do
    let!(:foram) { Fabricate(:foram) }

    before { delete :destroy, id: foram.id }

    it { should respond_with 204 }
  end
end
