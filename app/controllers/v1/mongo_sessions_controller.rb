module V1
  class MongoSessionsController < ApplicationController
    before_action :set_mongo_session, except: [:index, :create]

    def index
      render json: current_user.mongo_sessions
    end

    def create
      session = current_user.mongo_sessions.build session_params
      if session.save
        render json: session, status: :created
      else
        render json: session.errors, status: :unprocessable_entity
      end
    end

    def update
      if @session.update(session_params)
        render json: @session
      else
        render json: @session, status: :unprocessable_entity
      end
    end

    def destroy
      if @session.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    private

    def session_params
      params.require(:mongo_session).permit(:active, :name, :database, :username, :password, :foram_collection, hosts: [])
    end

    def set_mongo_session
      @session = current_user.mongo_sessions.find(params[:id])
    end
  end
end
