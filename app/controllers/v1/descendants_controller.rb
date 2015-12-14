module V1
  class DescendantsController < ApplicationController
    include ForamScoping
    before_action :set_foram

    def index
      render json: descendants_fetcher.fetch_descendants(@foram, descendants_params)
    end

    private

    def descendants_fetcher
      DescendantsFetcher.new foram_scoping
    end

    def descendants_params
      params.permit(:level)
    end

    def set_foram
      @foram = foram_scoping.find(params[:foram_id])
    end
  end
end
