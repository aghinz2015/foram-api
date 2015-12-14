require 'rails_helper'

describe 'Errors handler' do
  let(:user) { Fabricate(:user) }
  before do
    login(user)
  end

  context 'when REST resource not found' do
    before { get '/forams/unknown_resource', nil, { "HTTP_AUTHORIZATION" => @token_header } }

    it_behaves_like 'error handler', 404, 'REST resource not found'
  end

  context 'when route not resolved' do
    before { get '/unknown_endpoint', nil, { "HTTP_AUTHORIZATION" => @token_header } }

    it_behaves_like 'error handler', 404, 'API endpoint not found'
  end

  context 'when internal server error' do
    let!(:foram) { Fabricate :foram, id: 'f1' }

    before do
      allow_any_instance_of(V1::ForamsController).to receive(:show)
        .and_raise StandardError

      get '/forams/f1', nil, { "HTTP_AUTHORIZATION" => @token_header }
    end

    it_behaves_like 'error handler', 500, 'Internal server error'
  end
end
