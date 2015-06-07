module V1
  class ForamsController < ApplicationController
    before_action :set_foram, only: [:show, :update, :destroy]

    def index
      @forams = Foram.all

      render json: @forams
    end

    def show
      render json: @foram, root: true
    end

    def create
      @foram = Foram.new(foram_params)

      if @foram.save
        render json: @foram, status: :created, location: @foram
      else
        render json: @foram.errors, status: :unprocessable_entity
      end
    end

    def update
      if @foram.update(foram_params)
        head :no_content
      else
        render json: @foram.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @foram.destroy

      head :no_content
    end

    private

    def set_foram
      @foram = Foram.find(params[:id])
    end

    def foram_params
      params.require(:foram).permit(:kx, :ky, :kz, :tf, :phi, :beta)
    end
  end
end
