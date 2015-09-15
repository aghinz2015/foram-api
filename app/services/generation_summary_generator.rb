class GenerationSummaryGenerator
  attr_reader :grouping_parameter, :start, :stop, :genes

  def initialize(grouping_parameter, options = {})
    @grouping_parameter = grouping_parameter
    @genes = options[:genes]
    @start = options[:start].to_i if options[:start]
    @stop = options[:stop].to_i if options[:stop]
  end

  def summary
    @summary ||= generate_summary
  end

  private 

  def generate_summary
    return nil if genes.blank?
    metrics_calculator.generation_metrics
  end

  def metrics_calculator
    @metrics_calculator ||= GenerationMetricCalculator.new(Foram.all, grouping_parameter, genes, start: start, stop: stop)
  end
end