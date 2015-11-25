module V1
  class DescendantsController < ApplicationController
    before_action :set_foram

    def index
      render json: descendants_fetcher.fetch_descendants(@foram, descendants_params)
    end

    private

    def descendants_fetcher
      DescendantsFetcher.new(Foram.for_user(current_user))
    end

    def descendants_params
      params.permit(:level)
    end

    def set_foram
      @foram = Foram.for_user(current_user).find(params[:foram_id])
    end
  end
end
