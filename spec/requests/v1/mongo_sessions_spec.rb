require 'rails_helper'

describe V1::MongoSessionsController do
  describe "mongo sessions index" do
    context "when user is not logged in" do
      it "should return Unauthorized error" do
        get "/user/mongo_sessions"
        expect(response).to have_http_status 401
      end
    end

    context "when user is logged in" do
      subject { get "/user/mongo_sessions", nil, { "HTTP_AUTHORIZATION" => @token_header } }
      let(:user) { Fabricate(:user) }
      before do
        login(user)
      end

      it "should allow access" do
        subject
        expect(response).to have_http_status 200
      end

      context "when user has no mongo sessions" do
        let(:expected_json) { { mongo_sessions: [] } }

        it "should return empty array" do
          subject
          expect(json_response).to eq expected_json
        end
      end

      context "when user has some mongo sessions" do
        let(:sessions) do
          [
            Fabricate.build(:mongo_session, name: "A", database: "A_db", hosts: ["127.0.0.1:27800"], username: "tester"),
            Fabricate.build(:mongo_session, name: "B", database: "B_db", hosts: ["256.46.5.9:27800"], username: "test"),
          ]
        end

        before do
          user.mongo_sessions << sessions
          user.save
        end

        let(:expected_json) do
          { mongo_sessions: [
              { id: sessions[0].id.to_s, name: "A", database: "A_db", hosts: ["127.0.0.1:27800"], username: "tester", active: nil },
              { id: sessions[1].id.to_s, name: "B", database: "B_db", hosts: ["256.46.5.9:27800"], username: "test", active: nil }
            ]
          }
        end

        it "should return array with mongo sessions data" do
          subject
          expect(json_response).to eq expected_json
        end
      end
    end
  end
end
