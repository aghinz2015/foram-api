class GenerationSummaryGenerator
  attr_reader :grouping_parameter, :user, :simulation_start, :start, :stop, :genes

  def initialize(grouping_parameter, user, options = {})
    @grouping_parameter = grouping_parameter
    @user = user
    @simulation_start = options[:simulation_start]
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
    @metrics_calculator ||= begin
      criteria = {}
      criteria["#{grouping_parameter}_min"] = start if start
      criteria["#{grouping_parameter}_max"] = stop if stop
      GenerationMetricCalculator.new(ForamFilter.new(criteria).forams(user: user).simulation_start(simulation_start), grouping_parameter, genes)
    end
  end
end
