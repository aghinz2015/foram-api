require 'rails_helper'

describe 'Forams' do
  include_context 'forams'

  let(:user) { Fabricate(:user) }
  before do
    login(user)
  end

  describe 'GET /forams' do
    before { get '/forams', nil, { "HTTP_AUTHORIZATION" => @token_header } }

    let(:expected_forams) do
      {
        forams:
          [
            {
              id: 'f1',
              genotype: {
                translation_factor: {
                  effective:  0.1,
                  first_set:  0.2,
                  second_set: 0.3
                },

                growth_factor: {
                  effective:  0.2,
                  first_set:  0.3,
                  second_set: 0.4
                },

                rotation_angle: {
                  effective:  0.3,
                  first_set:  0.4,
                  second_set: 0.5
                },

                deviation_angle: {
                  effective:  0.4,
                  first_set:  0.5,
                  second_set: 0.6
                }
              }
            },

            {
              id: 'f2',
              genotype: {
                translation_factor: {
                  effective:  0.5,
                  first_set:  0.6,
                  second_set: 0.7
                },

                growth_factor: {
                  effective:  0.6,
                  first_set:  0.7,
                  second_set: 0.8
                },

                rotation_angle: {
                  effective:  0.7,
                  first_set:  0.8,
                  second_set: 0.9
                },

                deviation_angle: {
                  effective:  0.8,
                  first_set:  0.9,
                  second_set: 1.0
                }
              }
            }
          ]
        }
    end

    xit 'responds with all forams' do
      expect(json_response).to eq expected_forams
    end

    it 'responds with status 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'GET /forams/:id' do
    before { get "/forams/#{foram_id}", nil, { "HTTP_AUTHORIZATION" => @token_header } }

    context "when foram exists" do
      let(:foram_id) { 'f1' }

      let(:expected_foram) do
        {
          foram: {
            id: 'f1',
            genotype: {
              translation_factor: {
                effective:  0.1,
                first_set:  0.2,
                second_set: 0.3
              },

              growth_factor: {
                effective:  0.2,
                first_set:  0.3,
                second_set: 0.4
              },

              rotation_angle: {
                effective:  0.3,
                first_set:  0.4,
                second_set: 0.5
              },

              deviation_angle: {
                effective:  0.4,
                first_set:  0.5,
                second_set: 0.6
              }
            }
          }
        }
      end

      xit 'responds with specified foram' do
        expect(json_response).to eq expected_foram
      end

      it 'responds with status 200' do
        expect(response).to have_http_status 200
      end
    end

    context "when foram does not exist" do
      let(:foram_id) { 'unknown' }

      it_behaves_like 'error handler', 404, 'REST resource not found'
    end
  end
end
