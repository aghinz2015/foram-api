module V1
  class ForamFiltersController < ApplicationController
    before_action :set_filter, only: [:show, :update, :destroy]

    def index
      paginate json: current_user.foram_filters
    end

    def show
      render json: @filter
    end

    def create
      filter = current_user.foram_filters.new(foram_filter_params)

      if filter.save
        render json: filter, status: :created
      else
        render json: filter.errors, status: :unprocessable_entity
      end
    end

    def update
      if @filter.update(foram_filter_params)
        render json: @filter
      else
        render json: filter.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @filter.destroy
      head :no_content
    end

    def attribute_names
      only_numeric = params[:only_numeric] == 'true' ? true : false
      render json: Foram.filterable_attribute_names(user: current_user, only_numeric: only_numeric), root: :attributes
    end

    private

    def set_filter
      @filter = current_user.foram_filters.find params[:id]
    end

    def foram_filter_params
      params.require(:foram_filter).except!(:user_id).permit!
    end
  end
end
