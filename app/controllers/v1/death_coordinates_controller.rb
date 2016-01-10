module V1
  class DeathCoordinatesController < ApplicationController
    include ForamScoping

    def index
      render json: death_coordinates(foram_scope), serializer: HashSerializer, root: false
    end

    private

    def death_coordinates(forams)
      DeathCoordinatesAccumulator.new(forams, type.to_sym).data_hash
    end

    def type
      params[:type] || "2d_z"
    end
  end
end
