module V1
  class GenerationsController < ApplicationController

    def index
      summary_generator = GenerationSummaryGenerator.new(Foram.all)
      render json: { generations: summary_generator.summary }
    end

    private
  end
end
