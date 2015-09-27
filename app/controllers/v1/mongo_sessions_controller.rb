module V1
  class MongoSessionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_mongo_session, only: :update

    def index
      render json: current_user.mongo_sessions
    end

    def update
      if @session.update(session_params)
        render json: @session
      else
        render json: @session, status: :unprocessable_entity
      end
    end

    private

    def session_params
      params.require(:mongo_session).permit(:active)
    end

    def set_mongo_session
      @session = current_user.mongo_sessions.find(params[:id])
    end
  end
end
