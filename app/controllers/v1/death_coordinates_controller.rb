module V1
  class DeathCoordinatesController < ApplicationController
    def index
      render json: death_coordinates(Foram.for_user(current_user))
    end

    private

    def death_coordinates(forams)
      DeathCoordinatesAccumulator.new(forams, type.to_sym).data_hash
    end

    def type
      params[:type] || :bubble
    end
  end
end
