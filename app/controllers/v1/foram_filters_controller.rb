module V1
  class ForamFiltersController < ApplicationController
    def create
      foram_filter = ForamFilter.new foram_filter_params

      render json: foram_filter.forams
    end

    private

    def foram_filter_params
      params.require(:foram_filter).permit(:deviation_angle_min, :deviation_angle_max,
                                           :growth_factor_min, :growth_factor_max,
                                           :rotation_angle_min, :rotation_angle_max,
                                           :translation_factor_min, :translation_factor_max,
                                           :wall_thickness_factor_min, :wall_thickness_factor_max)
    end
  end
end
