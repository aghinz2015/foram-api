module V1
  class SettingsController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: current_user, serializer: Users::SettingsSerializer
    end

    def update
      if current_user.update(settings_params)
        render json: current_user
      else
        head :unprocessable_entity
      end
    end

    private

    def settings_params
      params.require(:settings).permit(:number_precision, :mappings)
    end
  end
end
