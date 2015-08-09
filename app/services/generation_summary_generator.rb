class GenerationSummaryGenerator
  attr_reader :forams

  def initialize(forams)
    @forams = forams
  end

  def summary
    { generations: @summary ||= generate_summary }
  end

  private 

  def generate_summary
    metrics_calculator.generation_metrics
  end

  def metrics_calculator
    @metrics_calculator ||= GenerationMetricCalculator.new(forams)
  end
end