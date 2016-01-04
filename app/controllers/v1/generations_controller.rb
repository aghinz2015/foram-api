module V1
  class GenerationsController < ApplicationController
    before_action :set_grouping_parameter

    ALLOWED_GROUPING_PARAMETERS = %w(death_hour age)


    def index
      summary_generator = GenerationSummaryGenerator.new(@grouping_parameter, current_user, foram_filter_params, summary_params)
      render json: { result: summary_generator.summary }
    end

    private

    def summary_params
      params.permit(:simulation_start, :start, :stop, genes: [])
    end

    def foram_filter_params
      attributes = ForamFilter.attributes_map(Foram.for_user(current_user)).keys
      params.slice(*attributes).to_hash
    end

    def set_grouping_parameter
      @grouping_parameter = if params[:group_by] && ALLOWED_GROUPING_PARAMETERS.include?(params[:group_by])
                              params[:group_by]
                            else
                              :death_hour
                            end
    end
  end
end
