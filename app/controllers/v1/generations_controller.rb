module V1
  class GenerationsController < ApplicationController
    before_action :set_grouping_parameter

    ALLOWED_GROUPING_PARAMETERS = %w(death_hour age)


    def index
      summary_generator = GenerationSummaryGenerator.new(@grouping_parameter, current_user, summary_params)
      render json: { result: summary_generator.summary }
    end

    private

    def summary_params
      params.permit(:start, :stop, genes: [])
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
