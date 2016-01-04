class GenerationSummaryGenerator
  attr_reader :grouping_parameter, :user, :criteria, :simulation_start, :start, :stop, :genes

  def initialize(grouping_parameter, user, criteria, options = {})
    @grouping_parameter = grouping_parameter
    @user = user
    @criteria = criteria
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
      @criteria["#{grouping_parameter}_min"] = start if start
      @criteria["#{grouping_parameter}_max"] = stop if stop
      forams = ForamFilter.new(criteria).forams(user: user).simulation_start(simulation_start)
      GenerationMetricCalculator.new(forams, grouping_parameter, genes)
    end
  end
end
