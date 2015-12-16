module V1
  class ForamsController < ApplicationController
    include ActionController::MimeResponds
    include ForamScoping

    before_action :set_foram, only: :show
    around_action :check_mongo_session_connection

    def index
      if params[:foram_filter_id]
        foram_filter = ForamFilter.find(params[:foram_filter_id])
      else
        foram_filter = ForamFilter.new(foram_filter_params)
      end
      forams = foram_filter.forams(user: current_user, order: ordering_params)
                           .simulation_start(params[:simulation_start])

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

    def simulation_starts
      render json: { simulation_starts: Foram.for_user(current_user).pluck(:simulationStart).uniq }
    end

    private

    def set_foram
      @foram = foram_scope.find(params[:id])
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
