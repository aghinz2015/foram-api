module V1
  class MongoSessionsController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: current_user.mongo_sessions
    end
  end
end
