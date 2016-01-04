module V1
  class ForamsController < ApplicationController
    include ActionController::MimeResponds
    include ForamScoping

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
      render json: Foram.all_attribute_names(user: current_user)
    end

    def attribute_stats
      forams = ForamFilter.new(foram_filter_params)
                          .forams(user: current_user)
                          .simulation_start(params[:simulation_start])
      render json: forams.attribute_stats(params[:attribute])
    end

    def simulation_starts
      render json: { simulation_starts: Foram.for_user(current_user).pluck(:simulationStart).uniq }
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
  end
end
