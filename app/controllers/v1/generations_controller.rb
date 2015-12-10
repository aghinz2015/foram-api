module V1
  class GenerationsController < ApplicationController
    before_action :set_grouping_parameter
    before_action :authenticate_user!

    ALLOWED_GROUPING_PARAMETERS = %w(death_step_no age generation)


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
                              :death_step_no
                            end
    end
  end
end
