module V1
  class ForamsController < ApplicationController
    include ActionController::MimeResponds

    before_action :authenticate_user
    before_action :set_foram, only: :show
    around_action :check_mongo_session_connection

    def index
      if params[:foram_filter_id]
        forams = ForamFilter.find(params[:foram_filter_id]).forams(user: current_user)
      else
        forams = ForamFilter.new(foram_filter_params).forams(user: current_user)
      end

      respond_to do |format|
        format.json { paginate json: forams }
        format.csv  { render csv: forams }
        format.gen  { render gen: forams }
      end
    end

    def show
      render json: @foram
    end

    private

    def set_foram
      @foram = Foram.for_user(current_user).find(params[:id])
    end

    def foram_filter_params
      params.permit(ForamFilter.params)
    end

    def check_mongo_session_connection
      yield
    rescue Moped::Errors::ConnectionFailure
      error = I18n.t("errors.mongo_sessions.connection_failure", ip_addresses: session.hosts)
      render json: { error: error }, status: :unprocessable_entity
    end
  end
end
