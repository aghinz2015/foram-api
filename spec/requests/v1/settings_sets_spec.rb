require 'rails_helper'

describe V1::SettingsSetsController do
  describe 'settings set show' do
    context 'when user is not logged in' do
      it 'should return Unauthorized error' do
        get '/user/settings_set'
        expect(response).to have_http_status 401
      end
    end

    context 'when user is logged in' do
      subject { get '/user/settings_set', nil, { "HTTP_AUTHORIZATION" => @token_header } }
      let(:user) { Fabricate(:user) }
      let(:expected_json) do
        { settings_set: { number_precision: user.settings_set.number_precision,
                          mappings: user.settings_set.mappings }
        }
      end
      before do
        login(user)
      end

      it 'should allow access' do
        subject
        expect(response).to have_http_status 200
      end

      it 'should return user settings set' do
        subject
        expect(json_response).to eq(expected_json)
      end
    end
  end

  describe 'settings set update' do
    context 'when user is not logged in' do
      it 'should return Unauthorized error' do
        patch '/user/settings_set'
        expect(response).to have_http_status 401
      end
    end

    context 'when user is logged in' do
      subject { patch '/user/settings_set', params, { "HTTP_AUTHORIZATION" => @token_header } }
      let(:user) { Fabricate(:user) }
      before do
        login(user)
      end

      context 'for valid params' do
        let(:params) { { settings_set: { mappings: { deviation_angle: 'Deviation angle' } } } }

        it 'updates settings' do
          subject
          expect(response).to be_success
          expect(user.reload.settings_set.mappings['deviation_angle']).to eq('Deviation angle')
        end
      end

      context 'for invalid params' do
        let(:params) { { settings_set: { mappings: { 'deviation.angle': 'Deviation angle' } } } }

        it 'returns uprocessable entity' do
          subject
          expect(response).to be_unprocessable
        end
      end
    end
  end
end
