module V1
  class ForamsController < ApplicationController
    before_action :set_foram, only: :show
    before_action :authenticate_user!
    def index
      forams = ForamFilter.new(foram_filter_params).forams

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
