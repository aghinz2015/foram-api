module V1
  class SettingsSetsController < ApplicationController
    before_action :set_settings_set

    def show
      render json: @settings_set
    end

    def update
      if @settings_set.update(settings_set_params)
        render json: @settings_set
      else
        head :unprocessable_entity
      end
    end

    private

    def settings_set_params
      params.require(:settings_set).permit(:number_precision, :tree_level).tap do |whitelisted|
        whitelisted[:mappings] = params[:settings_set][:mappings]
      end
    end

    def set_settings_set
      @settings_set = current_user.settings_set
    end
  end
end
