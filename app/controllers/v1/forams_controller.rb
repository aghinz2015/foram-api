module V1
  class ForamsController < ApplicationController
    include ActionController::MimeResponds

    before_action :set_foram, only: :show
    around_action :check_mongo_session_connection

    def index
      if params[:foram_filter_id]
        forams = ForamFilter.find(params[:foram_filter_id]).forams(user: current_user, order: ordering_params)
      else
        forams = ForamFilter.new(foram_filter_params).forams(user: current_user, order: ordering_params)
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

    def attribute_names
      render json: Foram.all_attribute_names(user: current_user)
    end

    private

    def set_foram
      @foram = Foram.for_user(current_user).find(params[:id])
    end

    def check_mongo_session_connection
      yield
    rescue Moped::Errors::ConnectionFailure
      error = I18n.t("errors.mongo_sessions.connection_failure", ip_addresses: session.hosts)
      render json: { error: error }, status: :unprocessable_entity
    end

    def ordering_params
      params.permit(:order_by, :direction)
    end

    def foram_filter_params
      attributes = ForamFilter.attributes_map(Foram.for_user(current_user)).keys
      params.slice(*attributes).to_hash
    end
  end
end
