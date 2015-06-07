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
