class GenerationMetricCalculator
  attr_reader :forams, :grouping_parameter, :genes, :generations

  PRECISION = 2
  ATTRIBUTE_TYPES = %i(effective first_set second_set)

  def initialize(forams, grouping_parameter, genes, start: nil, stop: nil)
    @forams = forams
    @grouping_parameter = grouping_parameter
    @genes = genes
    @start = start
    @stop = stop
  end

  def generation_metrics
    @metrics ||= begin
      group_by(grouping_parameter)
      { grouping_parameter: { name: grouping_parameter, values: generations.keys } }.
        merge!(calculate_metrics)
    end
  end

  private

  def group_by(param)
    @generations = {}

    forams.each do |foram|
      generation = foram.send(param).to_i
      @generations[generation] ||= []
      @generations[generation] << foram
    end
    @generations = @generations.sort.to_h
  end

  def calculate_metrics
    metrics_hash = {}
    globals = {}
    genes_hash = {}

    @generations.each do |number, forams|
      metrics_hash[number] = generation_metrics_hash(forams)
    end

    with_unpacked_metrics_hash(metrics_hash) do |unpacked_metrics, sizes_hash|
      genes_hash = unpacked_metrics
      globals = calculate_globals(unpacked_metrics, sizes_hash)
    end

    genes_hash.merge!(globals)
  end

  def generation_metrics_hash(forams)
    generation_hash = hash_with_initial_values(forams)
    fill_with_attributes_dependent_on_each_foram(generation_hash, forams)
    fill_with_attributes_dependent_on_whole_generation(generation_hash, forams)

    generation_hash
  end

  def hash_with_initial_values(forams)
    result = {}

    genes.each do |attribute|
      result[attribute] = {}
      ATTRIBUTE_TYPES.each do |type|
        value = forams.first.genotype.send(attribute).send(type)
        result[attribute][type] = { min: value, max: value, sum: 0, sum_of_squares: 0, size: 0 }
      end
    end

    result
  end

  def fill_with_attributes_dependent_on_each_foram(generation_hash, forams)
    forams.each do |foram|
      genotype = foram.genotype
      genes.each do |attribute|
        ATTRIBUTE_TYPES.each do |type|
          value = genotype.send(attribute).send(type)
          if value
            attribute_hash = generation_hash[attribute][type]
            attribute_hash[:size] += 1 

            attribute_hash[:min] = value if attribute_hash[:min].nil? || value < attribute_hash[:min]
            attribute_hash[:max] = value if attribute_hash[:max].nil? || value > attribute_hash[:max]
            attribute_hash[:sum] += value
            attribute_hash[:sum_of_squares] += value * value
          end
        end
      end
    end
  end

  def fill_with_attributes_dependent_on_whole_generation(generation_hash, forams)
    genes.each do |attribute|
      ATTRIBUTE_TYPES.each do |type|
        attribute_hash = generation_hash[attribute][type]

        size = attribute_hash[:size]
        if size > 0
          average = (attribute_hash[:sum].to_f / size)
          attribute_hash[:average] = average
          variance = (attribute_hash[:sum_of_squares].to_f / size) - average * average
          standard_deviation = Math.sqrt(variance)
          attribute_hash[:plus_standard_deviation] = average + standard_deviation
          attribute_hash[:minus_standard_deviation] = average - standard_deviation
        else
          attribute_hash[:average] = nil
          attribute_hash[:plus_standard_deviation] = nil
          attribute_hash[:minus_standard_deviation] = nil
        end

        attribute_hash.delete(:sum)
        attribute_hash.delete(:sum_of_squares)
      end
    end
  end

  def with_unpacked_metrics_hash(metrics_hash)
    result = {}
    sizes_hash = {}

    genes.each_with_index do |gene, index|
      gene_hash = { name: gene }
      sizes_hash[gene] = {}
      
      ATTRIBUTE_TYPES.each do |attribute_type|
        type_hash = {}
        sizes_hash[gene][attribute_type] = {}

        calculated_statistics = %i(min max average plus_standard_deviation minus_standard_deviation)
        calculated_statistics.each do |statistic|
          statistic_array = []
          metrics_hash.keys.each do |generation_number|
            size = metrics_hash[generation_number][gene][attribute_type][:size]
            sizes_hash[gene][attribute_type][generation_number] = size

            value = metrics_hash[generation_number][gene][attribute_type][statistic]
            value = value.round(PRECISION) if value
            statistic_array << value
          end
          type_hash[statistic] = statistic_array
        end

        gene_hash[attribute_type] = type_hash
      end

      result["gene#{index+1}"] = gene_hash
    end

    yield result, sizes_hash
  end

  def calculate_globals(metrics_hash, sizes_hash)
    globals_hash = {}

    genes.each do |gene|
      globals_hash[gene] = {}
      gene_key = metrics_hash.keys.select { |key| metrics_hash[key][:name] == gene }.first
      ATTRIBUTE_TYPES.each do |type|

        globals_hash[gene][type] = {}
       
        type_values_hash = metrics_hash[gene_key][type]

        globals_hash[gene][type][:min] = type_values_hash[:min].min 
        globals_hash[gene][type][:max] = type_values_hash[:max].max 

        sum_of_values = 0
        sum_of_sizes = 0

        sizes_array = sizes_hash[gene][type].values

        type_values_hash[:average].each_with_index do |average_value, index|
          size = sizes_array[index]
          if size > 0
            sum_of_values += average_value * size
            sum_of_sizes += size
          end
        end

        if sum_of_sizes > 0
          globals_hash[gene][type][:average] = (sum_of_values.to_f / sum_of_sizes).round(PRECISION)
        else
          globals_hash[gene][type][:average] = nil
        end
      end
    end

    { global: globals_hash }
  end
end
