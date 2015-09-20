require 'rails_helper'

describe MongoSession do
  include Mongoid::Matchers

  it { is_expected.to be_embedded_in :user }
  it { is_expected.to have_fields(:name, :database, :hosts, :username, :encrypted_password) }
  it { is_expected.to respond_to(:password=) }
  it { is_expected.not_to respond_to(:password) }

  it { is_expected.to validate_presence_of(:database) }
  it { is_expected.to validate_presence_of(:hosts) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:encrypted_password) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user) }

  describe 'password encryption' do
    subject { described_class.new(password: 'ala123') }

    it 'encrypts the password' do
      expect(subject.encrypted_password).to_not be_nil
    end
  end

  describe '#connect' do
    let(:user) { Fabricate.build(:user, username: 'testowy') }
    let(:session_hash) do
      {
        'hosts' => ['localhost:5640'],
        'database' => 'forams',
        'username' => 'testowy',
        'password' => 'test'
      }
    end
    subject do
      Fabricate.build(:mongo_session,
        name: 'main',
        hosts: ['localhost:5640'],
        database: 'forams',
        username: 'testowy',
        password: 'test'
      )
    end

    before do
      user.mongo_sessions << subject
    end

    it 'creates configuration in Mongoid' do
      subject.connect
      expect(Mongoid::Config.sessions[:testowy_main]).to eq session_hash
    end
  end
end
