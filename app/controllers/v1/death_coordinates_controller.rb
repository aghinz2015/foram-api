module V1
  class DeathCoordinatesController < ApplicationController
    include ForamScoping

    def index
      render json: death_coordinates(foram_scoping)
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
