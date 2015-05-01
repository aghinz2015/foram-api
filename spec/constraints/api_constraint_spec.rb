require 'rails_helper'

describe Constraints::APIConstraint do
  let(:api_constriant) { described_class.new options }

  describe '#matches?' do
    let(:request) { double :request }

    subject { api_constriant.matches?(request) }

    context 'when default flag set' do
      let(:options) { { version: 1, default: true } }

      it { should be_truthy }
    end

    context 'when default flag not set' do
      let(:options) { { version: 1 } }

      context 'when version specified in headers' do
        before { allow(request).to receive(:headers).and_return headers }

        context 'when matches version in constraint' do
          let(:headers) { { 'Accept' => 'application/vnd.foram.v1' } }

          it { should be_truthy }
        end

        context 'when does not match version in constraint' do
          let(:headers) { { 'Accept' => 'application/vnd.foram.v2' } }

          it { should be_falsey }
        end
      end
    end
  end
end
