module V1
  class ForamsController < ApplicationController
    include ActionController::MimeResponds
    include ForamScoping

    STORE_PERIOD = 5.minutes

    before_action :set_foram, only: :show

    def index
      if params[:foram_filter_id]
        foram_filter = ForamFilter.find(params[:foram_filter_id])
      else
        foram_filter = ForamFilter.new(foram_filter_params)
      end
      forams = foram_filter.forams(user: current_user, order: ordering_params)
                           .simulation_start(params[:simulation_start])

      respond_to do |format|
        format.json { paginate json: forams, per_page: current_user.settings_set.per_page }
        format.any(:gen, :csv) do
          creator = FileCreator.new(forams, format: params[:format])
          send_file creator.file.path, type: creator.content_type
        end
      end
    end

    def show
      render json: @foram
    end

    def attribute_names
      attribute_names = retrieve_attribute_names
      render json: attribute_names
    end

    def attribute_stats
      forams = ForamFilter.new(foram_filter_params)
                          .forams(user: current_user)
                          .simulation_start(params[:simulation_start])
      render json: forams.attribute_stats(params[:attribute])
    end

    def simulation_starts
      simulation_starts = retrieve_simulation_starts
      render json: { simulation_starts: simulation_starts }
    end

    def children_count
      count = descendants_fetcher.children_count(params[:id])
      render json: { children_count: count }
    end

    private

    def set_foram
      @foram = foram_scope.find(params[:id])
    end

    def ordering_params
      params.permit(:order_by, :direction)
    end

    def foram_filter_params
      attributes = ForamFilter.attributes_map(Foram.for_user(current_user)).keys
      params.slice(*attributes).to_hash
    end

    def retrieve_simulation_starts
      Rails.cache.fetch("#{current_user.active_mongo_session_id} simulation_starts", expires_in: STORE_PERIOD) do
        Foram.for_user(current_user).distinct(:simulationStart)
      end
    end

    def retrieve_attribute_names
      Rails.cache.fetch("#{current_user.active_mongo_session_id} attribute_names", expires_in: STORE_PERIOD) do
        Foram.all_attribute_names(user: current_user).to_a
      end
    end

    def descendants_fetcher
      DescendantsFetcher.new foram_scope
    end
  end
end
