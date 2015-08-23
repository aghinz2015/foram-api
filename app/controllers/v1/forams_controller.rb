module V1
  class ForamsController < ApplicationController
    before_action :set_foram, only: :show

    def index
      forams = ForamFilter.new(foram_filter_params).forams

      paginate json: forams
    end

    def show
      render json: @foram
    end

    private

    def set_foram
      @foram = Foram.find(params[:id])
    end

    def foram_filter_params
      params.permit(:deviation_angle_min, :deviation_angle_max,
                    :growth_factor_min, :growth_factor_max,
                    :rotation_angle_min, :rotation_angle_max,
                    :translation_factor_min, :translation_factor_max,
                    :wall_thickness_factor_min, :wall_thickness_factor_max)
    end
  end
end
