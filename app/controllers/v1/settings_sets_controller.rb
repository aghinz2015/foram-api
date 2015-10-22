module V1
  class SettingsSetsController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: current_user.settings_set
    end

    def update
      if current_user.settings_set.update(settings_set_params)
        render json: current_user.settings_set
      else
        head :unprocessable_entity
      end
    end

    private

    def settings_set_params
      params.require(:settings_set).permit(:number_precision).tap do |whitelisted|
        whitelisted[:mappings] = params[:settings_set][:mappings]
      end
    end
  end
end
