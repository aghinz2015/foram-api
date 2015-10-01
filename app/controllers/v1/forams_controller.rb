module V1
  class ForamsController < ApplicationController
    before_action :set_foram, only: :show

    def index
      if params[:foram_filter_id]
        forams = ForamFilter.find(params[:foram_filter_id]).forams
      else
        forams = ForamFilter.new(foram_filter_params).forams
      end

      paginate json: forams
    end

    def show
      render json: @foram
    end

    private

    def set_foram
      @foram = Foram.find(params[:id])
    end

    def foram_filter_params
      params.permit(ForamFilter.params)
    end
  end
end
