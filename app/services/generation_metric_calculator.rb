class GenerationMetricCalculator
  attr_reader :forams

  CALCULATED_ATTRIBUTES = %i(x y z age)
  PRECISION = 2

  def initialize(forams)
    @forams = forams
  end

  def generation_metrics
    @metrics ||= generate_metrics
  end

  private

  def generate_metrics
    group_by_generation
    calculate_metrics
  end

  def calculate_metrics
    metrics_hash = {}
    @generations.each do |number, forams|
      metrics_hash[number] = { attributes: generation_metrics_hash(forams) }
      metrics_hash[number][:size] = forams.size
    end
    metrics_hash = metrics_hash.sort.to_h
    metrics_hash[:global_averages] = calculate_global_averages(metrics_hash)
    metrics_hash
  end

  def group_by_generation
    @generations = {}

    forams.each do |foram|
      generation = foram.generation
      @generations[generation] ||= []
      @generations[generation] << foram
    end
  end

  def generation_metrics_hash(forams)
    generation_hash = {}

    CALCULATED_ATTRIBUTES.each do |attribute|
      value = forams.first.send(attribute)
      generation_hash[attribute] = { min: value, max: value, sum: 0, sum_of_squares: 0 }
    end

    forams.each do |foram|
      CALCULATED_ATTRIBUTES.each do |attribute|
        value = foram.send(attribute)
        attribute_hash = generation_hash[attribute]

        attribute_hash[:min] = value if value < attribute_hash[:min]
        attribute_hash[:max] = value if value > attribute_hash[:max]
        attribute_hash[:sum] += value
        attribute_hash[:sum_of_squares] += value * value
      end
    end

    CALCULATED_ATTRIBUTES.each do |attribute|
      attribute_hash = generation_hash[attribute]

      attribute_hash[:average] = (attribute_hash[:sum].to_f / forams.size).round(PRECISION)
      attribute_hash.delete(:sum)

      variance = (attribute_hash[:sum_of_squares].to_f / forams.size) - attribute_hash[:average] * attribute_hash[:average]

      attribute_hash[:standard_deviation] = Math.sqrt(variance).round(PRECISION)
      attribute_hash.delete(:sum_of_squares)
    end


    generation_hash
  end

  def calculate_global_averages(metrics_hash)
    averages_hash = {}

    CALCULATED_ATTRIBUTES.each do |attribute|
      sum_of_values = 0
      sum_of_sizes = 0

      metrics_hash.each_value do |generation_metrics|
        attribute_hash = generation_metrics[:attributes][attribute]

        sum_of_values += attribute_hash[:average] * generation_metrics[:size]
        sum_of_sizes += generation_metrics[:size]
      end

      averages_hash[attribute] = (sum_of_values.to_f / sum_of_sizes).round(PRECISION)
    end

    averages_hash
  end
end