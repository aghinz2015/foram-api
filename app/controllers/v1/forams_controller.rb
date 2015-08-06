module V1
  class ForamsController < ApplicationController
    before_action :set_foram, only: :show

    def index
      @forams = Foram.all

      render json: @forams
    end

    def show
      render json: @foram
    end

    private

    def set_foram
      @foram = Foram.find(params[:id])
    end
  end
end
