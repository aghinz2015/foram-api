require 'rails_helper'

describe V1::ForamsController do
  describe 'GET #show' do
    let!(:foram) { Fabricate(:foram) }

    before { get :show, id: foram.id }

    it 'renders json representation of existing foram record' do
      expect(json_response[:foram][:kx]).to eq foram.kx
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

  describe 'POST #create' do
    context 'when successfully created' do
      let(:foram_params) { Fabricate.attributes_for :foram }

      before { post :create, foram: foram_params }

      it 'renders json representation of created foram record' do
        expect(json_response[:foram]).to include(foram_params.symbolize_keys)
      end

      it { should respond_with 201 }
    end

    context 'when not created' do
      before { post :create, foram: { kx: 0.5 } }

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    let!(:foram) { Fabricate(:foram) }

    context 'when successfully updated' do
      before { patch :update, id: foram.id, foram: { kx: 0.5 } }

      it { should respond_with 204 }
    end

    context 'when not updated' do
      before { patch :update, id: foram.id, foram: { kx: nil } }

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    let!(:foram) { Fabricate(:foram) }

    before { delete :destroy, id: foram.id }

    it { should respond_with 204 }
  end
end
